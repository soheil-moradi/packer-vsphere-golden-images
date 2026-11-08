import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]
SKIP_PARTS = {".git", ".packer_cache", "__pycache__"}
SKIP_FILES = {"test_public_safety.py"}
FORBIDDEN_MARKERS = (
    "Hesaba",
    "172.20.",
    "company-vsphere-lab",
    "private-vsphere-deployment",
)


def iter_text_files():
    for path in ROOT.rglob("*"):
        if not path.is_file() or any(part in SKIP_PARTS for part in path.parts):
            continue
        if path.name in SKIP_FILES:
            continue
        if path.suffix.lower() in {".png", ".jpg", ".gif", ".zip"}:
            continue
        yield path


class PublicSafetyTests(unittest.TestCase):
    def test_public_tree_contains_no_private_markers(self):
        findings = []
        for path in iter_text_files():
            text = path.read_text(encoding="utf-8", errors="ignore")
            for marker in FORBIDDEN_MARKERS:
                if marker in text:
                    findings.append(f"{path}: {marker}")
        self.assertFalse(findings, "private markers found: " + ", ".join(findings))


    def test_real_variable_files_are_not_present(self):
        forbidden_suffixes = (".pkrvars.hcl", ".pkrvars.json")
        real_files = [
            path
            for path in ROOT.rglob("*")
            if path.is_file() and path.name.endswith(forbidden_suffixes)
            and not path.name.endswith(".example")
        ]
        self.assertFalse(real_files, f"real Packer variable files found: {real_files}")
