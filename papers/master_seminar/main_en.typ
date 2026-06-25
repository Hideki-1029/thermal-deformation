#import "template.typ": *

#show: project.with(
  id: "",
  title-ja: "Improving Optical Communication Coarse Acquisition 
  by Thermal-Deformation Bias Prediction and Adaptive Correction",
  language: "en",
  caption-separator: [ ],
  authors: (
    (
      name-ja: "Hideki Takamoto, M2, Funase-Ikari Laboratory (2026/6/19)",
      affiliation-ja: "",
      presenting: true,
    ),
  ),
  abstract: [
    This study investigates an acquisition performance improvement method for free-space optical communication by predicting and compensating line-of-sight (LOS) bias induced by thermal deformation. In optical satellite communication, the beam divergence angle is small, and the success of the pointing, acquisition, and tracking process strongly depends on the initial pointing uncertainty. During coarse acquisition, optical feedback is not yet available, so the terminal must scan an uncertainty region determined by orbit prediction errors, attitude determination errors, alignment errors, and structural deformation. This work focuses on the thermal-deformation component, which can appear as a slowly varying LOS bias caused by orbital thermal cycles, attitude conditions, equipment heat dissipation, and operational modes. The proposed framework combines feedforward correction based on predicted thermal-deformation-induced LOS bias with adaptive correction using residual pointing information obtained after acquisition. Thermal Desktop and structural analysis are considered for generating reference LOS-bias time series, while lightweight onboard prediction models such as physical thermal deformation, Fourier, orbital-geometry, and thermal-sensor models are evaluated. A coarse-acquisition simulation will compare no correction, static bias correction, feedforward correction, and feedforward plus adaptive correction in terms of acquisition success rate, acquisition time, initial pointing error, and required scan area.
  ],
  n-columns: 2,
)

= Introduction
== Background
Satellite optical communication is expected to provide high-capacity links for future small-satellite missions because it can achieve higher antenna gain and wider bandwidth than radio-frequency communication@2017-kaushal-survey. However, because optical beams have small divergence angles, the success of Pointing, Acquisition and Tracking (PAT) strongly affects whether the communication link can be established. In particular, during coarse acquisition, optical feedback is not yet available, and the terminal must scan an uncertainty region that includes orbit prediction errors, attitude determination errors, alignment errors, and other initial pointing errors@2023-riesing-tbird.

#figure(
  image("figure/image_modify_scan_area.png", width: 80%),
  caption: [Concept of scan-center correction using thermal-deformation-induced LOS bias],
)<fig_scan_area>

The acquisition time strongly depends on the size of the uncertainty region to be scanned. If the representative radius of the uncertainty region is denoted by $theta_U$, a simplified scan model gives an acquisition time $T_("acq")$ that is approximately proportional to $theta_U^2$. Therefore, if a predictable component of the initial pointing error can be compensated in advance, the required scan area, acquisition time, and reacquisition time can potentially be reduced.

== Thermal-Deformation-Induced LOS Bias
This study focuses on Line-of-Sight (LOS) bias caused by thermal deformation of the satellite structure and optical system as one component of the initial pointing error. In low Earth orbit, the temperature field varies with repeated sunlight and eclipse cycles, attitude conditions, equipment heat dissipation, and operational modes. This time-varying temperature field deforms the spacecraft structure and optical bench, and appears as relative displacement or relative angle between optical reference points. Although fine tracking can partly compensate for this error using received-light feedback, the LOS bias remains as an initial pointing error at the start of coarse acquisition.

#figure(
  image("figure/image_thermal_deformation_from_Shi.png", width: 88%),
  caption: [Example of satellite bus thermal deformation analysis@2023-shi-thermal],
)<fig_thermal_deformation_example>

Thermal-deformation-induced LOS bias can be non-negligible for optical communication coarse acquisition. For example, if $L$ is the representative distance between optical reference points and $Delta x$ is the relative displacement caused by thermal deformation, a small-angle approximation gives

$ Delta theta_("LOS") approx (Delta x) / L $

For $L = 1$ m and $Delta x = 100$--$200$ µm, $Delta theta_("LOS")$ becomes approximately $100$--$200$ µrad. This is comparable to the beam divergence angle, acquisition sensor field of view, and attitude-determination-related LOS error assumed for small-satellite optical communication, and can therefore contribute significantly to the coarse-acquisition uncertainty budget.

== Related Work and Position of This Study
Related work can be broadly divided into studies on opto-thermo-mechanical phenomena, studies on thermal-deformation-induced LOS correction, and studies on the acquisition-performance impact in optical communication. These studies provide the basis for this work, but a framework that connects predicted thermal-deformation-induced LOS bias to scan-center correction for coarse acquisition and evaluates its effect on acquisition time and required scan area has not been sufficiently investigated.

- #text(weight: "bold")[Opto-thermal and opto-thermo-mechanical phenomena]: Badás et al. reviewed how coupled thermal, structural, and optical phenomena in satellite FSOC terminals affect communication performance through pointing jitter, wavefront error, polarization changes, and related effects@2024-badas. However, they did not propose a specific method for using thermal-deformation-induced LOS bias in coarse-acquisition correction.

- #text(weight: "bold")[LOS and thermal-deformation-induced error correction]: Hu et al. modeled thermal-deformation-induced LOS errors of a GEO remote sensor using star observations and Fourier series for diurnal variation@2022-hu-thermal-motion, while Li et al. corrected LOS errors of LEO optical payloads using solar, satellite, and LOS geometry@2025-li-thermal-los. These approaches are mainly aimed at remote-sensing and observation payloads, and their effect on coarse acquisition time and scan area in optical communication PAT is not the primary target.

- #text(weight: "bold")[Acquisition-performance impact in optical communication]: Shi et al. showed that thermal deformation between a laser communication terminal and a star sensor increases the uncertainty region and acquisition time, and reduced the optical-axis angle variation using a common reference structure and flexible support@2023-shi-thermal. However, their focus is structural and thermal design for reducing deformation, rather than feedforward or adaptive correction using LOS bias predicted on orbit.

Based on these studies, this work treats thermal-deformation-induced time-varying LOS bias as an error component that is partially predictable from orbital phase and thermal state. The predicted bias is then used for scan-center correction during coarse acquisition, and its effect on acquisition time and required scan area is evaluated.

= Proposed Method
== Basic Approach
The objective of this study is to reduce the uncertainty region and acquisition time by predicting time-varying LOS bias caused by thermal deformation and correcting the scan center during coarse acquisition. Structural design for reducing thermal deformation is important, but it is difficult to absorb all operational conditions at the design stage. Therefore, this study applies the concept of thermal-deformation-induced LOS correction studied in remote sensing to optical communication coarse acquisition, and treats thermal deformation not simply as an unknown disturbance but as a low-frequency bias that is partially predictable from orbital phase, thermal environment, and operational mode.

This study does not aim to completely separate only the thermal-deformation component from observed pointing residuals. Initial pointing error during coarse acquisition simultaneously includes orbit prediction error, attitude determination error, alignment error, and errors on the counterpart terminal. The main question is how much the scan-center error and required scan area can be reduced by using prior information on thermal-deformation-induced LOS bias obtained from thermal-structural analysis and temperature/orbit information, even when these other error sources coexist.

The proposed correction consists of two layers: feedforward correction based on prior prediction and adaptive correction based on observed residuals. First, Thermal Desktop is used to analyze the orbital thermal environment and spacecraft temperature field, and structural analysis with Femap / Nastran is used to compute thermal deformation at each time. The obtained relative displacement and relative angle between optical reference points are converted into an LOS-bias time series, which is used as a high-fidelity reference for evaluating correction models. Next, this reference time series is used to construct lightweight LOS-bias prediction models suitable for onboard use.

== Feedforward Correction
In feedforward correction, the predicted LOS bias is added to the scan-center command at the start of coarse acquisition. Let $theta_("nom")(t)$ be the nominal pointing direction and $hat(Delta theta)_("LOS")(t)$ be the predicted LOS bias. The scan-center command is written as

$ theta_("scan")(t) = theta_("nom")(t) + u_("FF")(t), quad u_("FF")(t) = -hat(Delta theta)_("LOS")(t) $

This correction moves the scan center closer to the actual target direction shifted by thermal deformation, thereby reducing the residual pointing error $e_("scan")$.

Candidate lightweight models include a physical thermal deformation model that approximates thermal deformation and LOS bias from the satellite bus, optical-system structure, and temperature distribution, as well as a static bias model using the mean LOS bias, a Fourier model with respect to orbital phase, an orbital geometry model using Sun-satellite-LOS geometry, and a thermal sensor model using temperature sensor values. In the physical model, thermal expansion of the optical bench and mounting structure, relative displacement and relative angle between optical reference points, and sensitivity to the communication optical axis are represented in a simplified form and reduced to an onboard-tractable correction model. For GEO remote sensors, thermal-deformation-induced LOS errors have been corrected using star observations and Fourier series@2022-hu-thermal-motion. For LEO, where illumination conditions are unstable, Li et al. corrected thermal-deformation-induced LOS errors using a machine-learning model based on on-orbit star observations@2025-li-thermal-los. This study connects these LOS-correction concepts to scan-center correction for optical communication coarse acquisition.

== Adaptive Correction
Feedforward correction can reduce the initial error, but uncertainty remains in the thermal-structural analysis model, the lightweight prediction model, and the actual on-orbit thermal environment. Therefore, after acquisition, residuals between the predicted LOS bias and observed pointing error are estimated using PAT sensor outputs, Quadrant Detector (QD), Focal Plane Module (FPM), received optical power, and attitude sensor information.

However, observed residuals include not only thermal deformation but also attitude determination error, orbit prediction error, alignment residuals, and mechanical vibration. Therefore, adaptive correction aims to extract low-frequency residual components correlated with thermal state or orbital phase and incorporate them into the correction model. Specifically, residuals obtained at each acquisition event are accumulated, and model parameters with respect to orbital phase, sunlight/eclipse state, temperature sensor values, and operational mode are updated sequentially. This improves robustness against structural changes after launch and long-term changes in thermal characteristics.

#figure(
  image("figure/concept_feedforward_adaptive_correctoion.png", width: 88%),
  caption: [Two-layer correction framework combining feedforward and adaptive correction],
)<fig_ff_adaptive>

= Evaluation Plan
== Simulation Setup
The effectiveness of the proposed method will be evaluated by coarse-acquisition simulations including thermal-deformation-induced LOS bias. Four cases will be compared: no correction, static bias correction, feedforward correction, and feedforward plus adaptive correction. The no-correction case treats the thermal-deformation-induced bias directly as an initial pointing error. Static bias correction compensates only for the time-averaged LOS offset. In feedforward correction, a physical thermal deformation model based on the satellite bus, optical-system structure, and thermal state is the main candidate, and LOS bias predicted from orbital phase and temperature information is used. Feedforward plus adaptive correction additionally updates the model based on observed residuals.

The evaluation metrics are acquisition success rate, mean acquisition time, initial pointing error, and required scan area. Since the search cost in coarse acquisition corresponds to the area of the uncertainty region, the required scan area is evaluated using the variance or upper bound of the residual after correction. The evaluation will compare all correction cases while leaving orbit prediction error and attitude determination error as disturbances, so that thermal-deformation correction is evaluated not as a method for removing all errors but as a method for reducing the predictable thermal component.

#figure(
  image("figure/thermal_los_bias_from_mock_analysis.png", width: 100%),
  caption: [Mock thermal LOS bias and feedforward estimate],
)<fig_mock_los_bias>

#figure(
  image("figure/coarse_acq_time_from_mock_analysis.png", width: 100%),
  caption: [Preliminary coarse-acquisition time analysis using mock thermal LOS bias],
)<fig_mock_acq_time>

Preliminary numerical experiments using mock thermal LOS bias show that adding feedforward correction reduces the mean initial error from $93.9$ µrad to $49.5$ µrad and the mean acquisition time from $2.43$ s to $0.74$ s compared with no correction. In future work, this hypothetical model will be replaced with reference time series based on Thermal Desktop / Femap analysis, and the effect of modeling errors will be evaluated.

#figure(
  table(
    columns: (1.5fr, 2.2fr, 2.0fr),
    align: left,
    [Case], [Correction], [Evaluation purpose],
    [No correction], [Thermal-deformation-induced LOS bias is not corrected], [Baseline performance],
    [Static bias], [Only a fixed LOS offset is corrected], [Comparison with steady correction],
    [Feedforward], [Scan center is corrected using LOS bias predicted by a physical thermal deformation model and related lightweight models], [Effect of prior thermal model],
    [FF+Adaptive], [Correction model is updated based on observed residuals], [Robustness against model error],
  ),
  caption: [Correction cases and evaluation purpose],
)<tab_cases>

== Expected Outcomes and Remaining Issues
The contribution of this study is to connect thermal-deformation correction not only to LOS-error reduction but also directly to improvement of optical communication PAT coarse-acquisition performance. Thermal deformation has often been treated as a target of structural and thermal design, but this study models it as a time-varying LOS bias and uses it for scan-center correction. This can potentially reduce the uncertainty region at the start of coarse acquisition and shorten acquisition and reacquisition times.

There are three remaining issues. First, LOS-bias reference time series must be generated for representative satellite structures and orbital conditions using Thermal Desktop / Femap analysis. Second, lightweight correction models such as the physical thermal deformation model, Fourier model, orbital geometry model, and thermal sensor model must be compared to determine suitable inputs and model order for onboard implementation. Third, methods must be designed to extract low-frequency residuals correlated with thermal state from PAT, attitude, and thermal sensor information. In particular, if error sources other than thermal deformation are incorrectly incorporated into the model, the correction may become unstable, so residual decomposition and model update rules are important.

= Conclusion
This paper organized the impact of time-varying LOS bias caused by thermal deformation on optical communication coarse acquisition, and proposed a feedforward / adaptive correction framework that uses predicted LOS bias for scan-center correction. Thermal-deformation-induced LOS bias can be on the order of several tens to several hundreds of µrad, comparable to beam divergence and acquisition sensor field of view, and therefore can be a non-negligible contributor to the coarse-acquisition uncertainty region. Future work will generate high-fidelity reference time series based on thermal-structural analysis and compare no correction, static correction, feedforward correction, and feedforward plus adaptive correction in coarse-acquisition simulations to quantitatively evaluate the effect of the proposed method on acquisition success rate, acquisition time, and required scan area.

#bibliography(
  "bibliography.bib",
  title: [References],
  style: "bibstyle.csl",
)
