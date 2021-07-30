from cvss import (
    CVSS3,
)
import json
import sys
from typing import (
    Tuple,
)


def main(vector: str) -> None:
    result: CVSS3 = CVSS3(vector)
    scores: Tuple[float, float, float] = result.scores()
    severities: Tuple[str, str, str] = result.severities()

    print(
        json.dumps(
            {
                "score": {
                    "base": scores[0],
                    "temporal": scores[1],
                    "environmental": scores[2],
                },
                "severity": {
                    "base": severities[0],
                    "temporal": severities[1],
                    "environmental": severities[2],
                },
            }
        )
    )


if __name__ == "__main__":
    main(sys.argv[1])
