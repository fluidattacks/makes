import os
import sys
from typing import (
    Set,
)


def main() -> None:
    # Compute requirements
    closure: Set[str] = load_requirements_txt(sys.argv[1])
    deps: Set[str] = load_requirements_txt(sys.argv[2])
    sub_deps: Set[str] = load_requirements_txt(sys.argv[3])

    print("Closure:")
    for dep in sorted(closure):
        print(f"  {dep}")

    error_on_non_canonical_names(closure, deps, sub_deps)
    error_on_missing_sub_deps(closure, deps, sub_deps)


def error_on_non_canonical_names(
    closure: Set[str],
    deps: Set[str],
    sub_deps: Set[str],
) -> None:
    non_canonical: Set[str] = {
        dep for dep in sorted(deps | sub_deps) if dep not in closure
    }
    if non_canonical:
        print()
        print("Names can only contain: lowercase letters, numbers and dashes")
        for dep in non_canonical:
            print(f"  {dep}")
        sys.exit(1)


def error_on_missing_sub_deps(
    closure: Set[str],
    deps: Set[str],
    sub_deps: Set[str],
) -> None:
    missing_sub_deps: Set[str] = {
        dep for dep in closure if dep not in deps and dep not in sub_deps
    }
    if missing_sub_deps:
        print()
        print("Please add as sub-dependencies:")
        for dep in sorted(missing_sub_deps):
            print(f"  {dep}")
        sys.exit(1)


def format_pkg(name: str, version: str) -> str:
    return f'"{name}" = "{version}";'


def load_requirements_txt(path: str) -> Set[str]:
    with open(path) as handle:
        return set(
            format_pkg(*pkg.split("==")) for pkg in handle.read().splitlines()
        )


if __name__ == "__main__":
    main()
