import re
import io
import sys
from pathlib import Path

def main():
    n_args = len(sys.argv)
    if(n_args > 1):
        dirpath = sys.argv[1]
        direc = Path(dirpath).glob("*/*.csv")
        for item in direc:
            print(item.name)
            content = item.read_text()
            #^[a-zA-Z0-9,.+-/]
            new_content = re.sub('\"','',content)
            print(new_content.find('\"') >= 0)
            item.write_text(new_content)
    else:
        print("usage: preprocess.py \"pathToDirectory\"")

if __name__ == "__main__":
    main()
