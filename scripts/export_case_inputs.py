from export_case_matrix import DEFAULT_INPUT as CASE_MATRIX_XLSX
from export_case_matrix import DEFAULT_OUTPUT as CASE_MATRIX_CSV
from export_case_matrix import export_case_matrix
from export_orbit_catalog import DEFAULT_INPUT as ORBIT_CATALOG_XLSX
from export_orbit_catalog import DEFAULT_OUTPUT as ORBIT_CATALOG_CSV
from export_orbit_catalog import export_orbit_catalog


def main():
    case_count = export_case_matrix(
        CASE_MATRIX_XLSX,
        CASE_MATRIX_CSV,
        sheet_name="case_matrix",
    )
    orbit_count = export_orbit_catalog(
        ORBIT_CATALOG_XLSX,
        ORBIT_CATALOG_CSV,
        sheet_name="orbit_catalog",
    )

    print(f"Exported {case_count} cases")
    print(f"Output: {CASE_MATRIX_CSV}")
    print(f"Exported {orbit_count} orbits")
    print(f"Output: {ORBIT_CATALOG_CSV}")


if __name__ == "__main__":
    main()
