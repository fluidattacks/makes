from cvss import (
    CVSS3,
)
import json
import sys
from typing import (
    Tuple,
)


def _round(scores: Tuple[float, float, float]) -> Tuple[float, float, float]:
    return tuple(round(score, 1) for score in scores)


def main(vector: str) -> None:
    result: CVSS3 = CVSS3(vector)
    scores: Tuple[float, float, float] = _round(result.scores())
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
