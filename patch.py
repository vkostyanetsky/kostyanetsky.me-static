#!/usr/bin/env python3

from __future__ import annotations

import sys
from pathlib import Path

import yaml


def has_frontmatter(text: str) -> bool:
    return text.startswith("---\n") or text.startswith("---\r\n")


def build_frontmatter(data: object) -> str:
    if not isinstance(data, dict):
        raise ValueError("index.yaml must contain a YAML mapping/object at top level")

    yaml_text = yaml.safe_dump(
        data,
        allow_unicode=True,
        sort_keys=False,
        default_flow_style=False,
    ).strip()

    return f"---\n{yaml_text}\n---\n\n"


def read_text_no_bom(path: Path) -> str:
    # utf-8-sig убирает BOM, если он есть в начале файла
    return path.read_text(encoding="utf-8-sig").lstrip("\ufeff")


def migrate_pair(md_path: Path, yaml_path: Path) -> str:
    md_text = read_text_no_bom(md_path)

    if has_frontmatter(md_text):
        return "skipped (frontmatter already exists)"

    yaml_text = read_text_no_bom(yaml_path)
    yaml_data = yaml.safe_load(yaml_text)
    if yaml_data is None:
        yaml_data = {}

    frontmatter = build_frontmatter(yaml_data)
    new_md_text = frontmatter + md_text

    # пишем уже как обычный utf-8, без BOM
    md_path.write_text(new_md_text, encoding="utf-8")
    return "updated"


def main() -> int:
    root = Path.cwd()
    processed = 0
    updated = 0
    skipped = 0
    errors = 0

    for md_path in root.rglob("index.md"):
        yaml_path = md_path.with_name("index.yaml")
        if not yaml_path.exists():
            continue

        processed += 1

        try:
            result = migrate_pair(md_path, yaml_path)
            rel_path = md_path.relative_to(root)

            if result == "updated":
                updated += 1
            else:
                skipped += 1

            print(f"{rel_path}: {result}")

        except Exception as exc:
            errors += 1
            rel_path = md_path.relative_to(root)
            print(f"{rel_path}: error: {exc}", file=sys.stderr)

    print()
    print(f"Found pairs: {processed}")
    print(f"Updated:    {updated}")
    print(f"Skipped:    {skipped}")
    print(f"Errors:     {errors}")

    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())