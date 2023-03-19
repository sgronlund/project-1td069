import numpy as np
import pandas as pd
import glob
import os

from multiprocessing import Pool
from progressbar import ProgressBar


def main():
    folder = 'data'
    save_folder = 'numerical_data'
    
    year_start = 2023
    year_end = 2023
    n_thread = 4

    for year in range(year_start, year_end + 1):
        process_year(folder, save_folder, year, n_thread)

def process_year(folder, save_folder, year, n_thread):
    print(f'Processing year {year}...')

    os.makedirs(f'{save_folder}/{year}', exist_ok=True)
    csv_files = sorted(list(glob.glob(f'{folder}/{year}/*.csv')))

    def update(arg):
        pbar.update(arg)

    pbar = ProgressBar(len(csv_files))

    pool = Pool(n_thread)
    for csv_path in csv_files:
        pool.apply_async(
            worker,
            args=(csv_path, folder, save_folder),
            callback=update,
        )
    pool.close()
    pool.join()
    print("All subprocesses done.")

def worker(csv_path, folder, save_folder):
    df = pd.read_csv(csv_path, parse_dates=['DATE'], na_values='NULL')
    df = df.apply(lambda x: x.replace({' ':'-1', '\*':'1'}, regex=True))
    df.to_csv(csv_path.replace(folder, save_folder), index=False)
    return "Processing {:s} ...".format(csv_path)


if __name__ == "__main__":
    main()