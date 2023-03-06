import re
import io
import sys
from pathlib import Path

def main():
    n_args = len(sys.argv)
    if(n_args > 2):
        year_start = sys.argv[1]
        year_end = sys.argv[2]
        for year in range(year_start, year_end):
            direc = Path("data/").glob(f"{year}/*.csv")
            for item in direc:
                content = item.read_text()
                new_content = re.sub('\"','',content)
                item.write_text(new_content)
    else:
        print("usage: preprocess.py \"yearStart\" \"yearEnd\"")

if __name__ == "__main__":
    main()
