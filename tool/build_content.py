#!/usr/bin/env python3
"""Convertit les listes compactes tool/content/<langue>/*.txt en
assets/content/<langue>/vocabulary.json (format du cahier des charges v2).

Format d'une ligne :
  mot|article|formes|nature|traductions (;)|situation|exemple cible|exemple FR[|transcription mot|transcription exemple]

Grec : l'article est ο / η / το (pluriel οι / τα), la transcription latine est obligatoire.
Latin : pas d'article ; la colonne « article » contient le genre (m, f, n) des noms.

Usage : python3 tool/build_content.py de
"""
import json
import re
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GENDERS = {
    "de": {"der": "m", "die": "f", "das": "n"},
    "el": {"ο": "m", "η": "f", "το": "n", "οι": "pl", "τα": "pl"},
    "la": {"m": "m", "f": "f", "n": "n"},
}
# Langues où la colonne « article » ne contient que le genre.
GENDER_ONLY = {"la"}
POS = {
    "n": "noun", "v": "verb", "adj": "adjective", "adv": "adverb",
    "prep": "preposition", "pron": "pronoun", "conj": "conjunction",
    "det": "determiner", "num": "numeral", "intj": "interjection",
    "phr": "phrase",
}


def slug(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


def main(lang: str) -> None:
    src = ROOT / "tool" / "content" / lang
    entries = []
    seen = set()
    for path in sorted(src.glob("*.txt")):
        for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if not line.strip() or line.startswith("#"):
                continue
            fields = line.split("|")
            if len(fields) not in (8, 10):
                sys.exit(f"{path.name}:{n}: 8 ou 10 champs attendus, {len(fields)} trouvés")
            fields = [f.strip() for f in fields] + ["", ""]
            word, article, forms, pos, fr, situation, ex_t, ex_fr, translit, ex_translit = fields[:10]
            # « sein (possessif) » : le mot prononcé est « sein », la précision s'affiche.
            note = None
            m = re.fullmatch(r"(.+?) \((.+)\)", word)
            if m:
                word, note = m.group(1), m.group(2)
            translations = [t.strip() for t in fr.split(";") if t.strip()]
            key = (word, article, translations[0])
            if key in seen:
                continue
            seen.add(key)
            forms = None if forms in ("", "-") else forms
            gender = GENDERS.get(lang, {}).get(article)
            if lang in GENDER_ONLY:
                article = ""
            elif pos == "n" and not article:
                gender = "pl"  # « Leute », « Eltern » : pluriels sans singulier
            entries.append({
                "id": f"{lang}_{len(entries) + 1:04d}",
                "concept": slug(translations[0]),
                "word": word,
                "article": article or None,
                "gender": gender,
                # Latin : la forme donnée avec un nom est le génitif, pas le pluriel.
                "plural": forms if pos == "n" and lang not in GENDER_ONLY else None,
                "forms": forms if pos != "n" or lang in GENDER_ONLY else None,
                "note": note,
                "pos": POS.get(pos, pos),
                "translations_fr": translations,
                "frequency_rank": len(entries) + 1,
                "situation": situation,
                "transliteration": translit or None,
                "example": {"target": ex_t, "fr": ex_fr, "transliteration": ex_translit or None},
            })
    out = ROOT / "assets" / "content" / lang / "vocabulary.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(entries, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"{len(entries)} mots -> {out.relative_to(ROOT)}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "de")
