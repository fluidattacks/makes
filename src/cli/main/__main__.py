import sys

if __name__ == "__main__":
    try:
        from cli import (
            main,
        )

        main(sys.argv)
    except KeyboardInterrupt:
        sys.exit(130)
