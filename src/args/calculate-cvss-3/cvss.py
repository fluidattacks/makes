from cvss import (
    CVSS3,
)
import json
import logging
import sys
from typing import (
    Tuple,
)

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

formatter = logging.Formatter("[%(levelname)s] %(message)s")

console_handler.setFormatter(formatter)
LOGGER.addHandler(console_handler)


def _str(scores: Tuple[float, float, float]) -> Tuple[str, str, str]:
    return tuple(str(score) for score in scores)


def main(vector: str) -> None:
    result: CVSS3 = CVSS3(vector)
    scores: Tuple[str, str, str] = _str(result.scores())
    severities: Tuple[str, str, str] = result.severities()

    LOGGER.info(
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
