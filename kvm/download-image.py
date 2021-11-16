#!/usr/bin/python3
import hashlib
import os
import sys
from functools import reduce
from urllib.request import urlretrieve, urlopen

base_url="https://cloud.centos.org/centos/7/images/"
image_name='CentOS-7-x86_64-GenericCloud-2111.qcow2'

def download_file(url) -> str:
    with urlopen(url) as f:
        return f.read().decode('utf-8')

def local_sha256(filename) -> str:
    sha256 = hashlib.sha256()
    with open(filename, 'rb') as f:
        reduce(lambda _, c: sha256.update(c), iter(lambda: f.read(sha256.block_size * 128), b''), None)
    return sha256.hexdigest()

def remote_sha256(url):
    data = download_file(url + '.sha256')
    return [l for l in data.splitlines() if '.qcow2' in l][0].split()[0]

def download_image(url: str, dst):
    last_percent_reported = 0

    def reporthook(count, blockSize, totalSize):
        nonlocal last_percent_reported
        percent = int(count * blockSize * 100 / totalSize)
        progress = int(count * blockSize * 50 / totalSize)

        if last_percent_reported == percent:
            return

        sys.stdout.write("\r[%s%s] %d%%" % ('=' * progress, ' ' * (50-progress), percent))
        sys.stdout.flush()

        last_percent_reported = percent

    print("downloading " + url)

    urlretrieve(url, dst, reporthook=reporthook)
    print()


if __name__ == '__main__':
    dst = 'lfce_centos7.qcow2'
    url = base_url + image_name
    if os.path.isfile(dst) and local_sha256(dst) == remote_sha256(url):
        print('already downloaded.')
    else:
        download_image(url, dst)