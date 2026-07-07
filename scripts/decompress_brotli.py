import os
import sys

try:
    import brotli
except Exception:
    print('Missing brotli module. Install with: pip install brotli')
    sys.exit(2)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BUILD_DIR = os.path.join(ROOT, 'Build')

if not os.path.isdir(BUILD_DIR):
    print('Build directory not found:', BUILD_DIR)
    sys.exit(1)

for name in os.listdir(BUILD_DIR):
    if name.endswith('.br'):
        src = os.path.join(BUILD_DIR, name)
        dest = os.path.join(BUILD_DIR, name[:-3])
        print('Decompressing', src, '→', dest)
        with open(src, 'rb') as f_in:
            data = f_in.read()
        try:
            out = brotli.decompress(data)
        except brotli.error as e:
            print('Brotli decompression failed for', src, '-', e)
            continue
        with open(dest, 'wb') as f_out:
            f_out.write(out)
print('Done')
