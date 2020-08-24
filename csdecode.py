import base64
import hashlib
import io
from typing import Iterable

import jwrap
import re
import argparse

key = base64.b64decode(b"MzMyYzVmY2IyMjBmNmZjZA==")
e_sig = re.compile(r"^\d+\.5U8\+D0C")
ignored_hashes = [
    "b62c4641bf115c03a3f3ecb82d71c2b752c8c09d",
    "3a251b12530c6139631f74c224187125f0ab1cee",
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("--inplace", action="store_true")
    args = ap.parse_args()

    decoded_io = io.StringIO()
    with open(args.file, "r") as f:
        for line in decode_file(f):
            decoded_io.write(line)
    if args.inplace:
        with open(args.file, "w") as f:
            f.write(decoded_io.getvalue())
        print(f"Rewrote {args.file}")
    else:
        print(decoded_io.getvalue())


def decode_file(f: Iterable[str]) -> Iterable[str]:
    for line in f:
        if (
            line.startswith("<")
            and hashlib.sha1(line.strip().encode()).hexdigest() in ignored_hashes
        ):
            continue
        if e_sig.search(line):
            data = jwrap.decode_juce_base64(line.encode().strip())
            result_length, res = jwrap.decrypt_blowfish(key, data)
            assert result_length > 0
            line = res[:result_length].decode()
        yield line


if __name__ == "__main__":
    main()
