from os import listdir, getcwd, mkdir, path, remove
import argparse
import subprocess
from shutil import rmtree

FAIL = False

cwd = f'{getcwd()}/reg-tests'
parser = argparse.ArgumentParser(
    description="Runs regression tests for lingo files")
parser.add_argument("-c", "--clean", action='store_true')
parser.add_argument("-s", "--src-file", default=None)
parser.add_argument("-d", "--src-dir", default=f'{cwd}/src')
parser.add_argument("-o", "--diff-dir", default=f'{cwd}/diff')
parser.add_argument("-ll", "--llvm-dir", default=f'{cwd}/llvm')
parser.add_argument("-asm", "--asm-dir", default=f'{cwd}/asm')
parser.add_argument("-ex", "--exec-dir", default=f'{cwd}/exec')
parser.add_argument("-out", "--out-dir", default=f'{cwd}/out')

parser.add_argument("-lib", default=f'{getcwd()}/lib/lib.c')
args = parser.parse_args()

diff_dir = args.diff_dir
in_src_file = args.src_file
src_dir = args.src_dir
llvm_dir = args.llvm_dir
asm_dir = args.asm_dir
exec_dir = args.exec_dir
out_dir = args.out_dir
lib = args.lib


class RunException(Exception):
    def __init__(self, args, returncode, stdout, stderr):
        self.args = args
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr

    def tuple(self):
        return self.args, self.returncode, self.stdout, self.stderr


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def run(args):
    proc = subprocess.run(args, capture_output=True)
    args, returncode, stdout, stderr = \
        args, proc.returncode, proc.stdout, proc.stderr
    if returncode != 0:
        raise RunException(args, returncode, stdout, stderr)
    return stdout, stderr


def log(msg, should_print=True):
    if should_print:
        print(msg)
    with open(f'{cwd}/log.txt', 'a+') as file:
        file.write(msg + '\n')


def get_llvm(src, llvm_file):
    stdout, _ = run(
        ["dune", "exec", f'{"./src/lingo.exe"}', f'{src_dir}/{src}'])
    with open(llvm_file, 'wb') as file:
        file.write(stdout)


def build_asm(llvm_file, asm_file):
    run(["llc", llvm_file, "-o", asm_file])


def build_exec(asm_file, exec_file):
    run(["gcc", "-no-pie", asm_file, lib, "-o", exec_file])


def run_exec(execu, out):
    stdout, _ = run([execu])
    with open(out, 'w') as file:
        file.write(stdout.decode('utf-8'))


def diff_output(lingo_file, expected, actual, out):
    try:
        run(["diff", expected, actual])
        log(f'{bcolors.OKGREEN}...{lingo_file} PASSED ✓{bcolors.ENDC}\n')
    except RunException as err:
        args, returncode, stdout, stderr = err.tuple()

        global FAIL
        FAIL = True

        log(f'{" ".join(args)} returned {returncode}')
        log(f'STDOUT: \n {stdout.decode("utf-8")}')
        log(f'STDERR: \n {stderr.decode("utf-8")}')
        log(f'{bcolors.FAIL}Diff between {expected} '
            f'and {actual}.{bcolors.ENDC}')
        log(f'{bcolors.FAIL}...{lingo_file} FAILED ✕{bcolors.ENDC}\n')

        with open(out, 'wb') as file:
            file.write(stdout)


def run_test(src_file):
    lingo_file = f'{src_file}.lingo'
    llvm_file = f'{llvm_dir}/{src_file}.llvm'
    asm_file = f'{asm_dir}/{src_file}.s'
    execu_file = f'{exec_dir}/{src_file}.exe'
    expected_out_file = f'{out_dir}/{src_file}.out'
    out_file = f'{out_dir}/{src_file}.actual.out'
    diff_file = f'{diff_dir}/{src_file}.diff'

    log(f'{bcolors.WARNING}---------- TESTING '
        f'{lingo_file}... ----------{bcolors.ENDC}')
    try:
        get_llvm(lingo_file, llvm_file)
        build_asm(llvm_file, asm_file)
        build_exec(asm_file, execu_file)
        run_exec(execu_file, out_file)
    except RunException as err:
        _, _, _, stderr = err.tuple()
        with open(out_file, 'w') as file:
            file.write(stderr.decode('utf-8'))

    diff_output(lingo_file, expected_out_file, out_file, diff_file)


def clean():
    print(f'{bcolors.OKCYAN}CLEANING...{bcolors.ENDC}')
    # Get Rid of llvm, asm, exec, diff, .actual.out

    to_delete = [llvm_dir, asm_dir, exec_dir, diff_dir]
    for p in to_delete:
        if path.exists(p):
            rmtree(p)

    for f_name in listdir(out_dir):
        if 'actual.out' in f_name:
            remove(f'{out_dir}/{f_name}')

    log = f'{cwd}/log.txt'
    if path.exists(log):
        remove(log)


def make_dirs():
    to_create = [llvm_dir, asm_dir, exec_dir, diff_dir]
    for p in to_create:
        if not path.exists(p):
            mkdir(p)


if args.clean:
    clean()
    run(["dune", "clean"])
else:
    make_dirs()
    run(["dune", "build"])
    if in_src_file:
        run_test(in_src_file)

    else:
        for in_src_file in listdir(src_dir):
            in_src_f, *rest = in_src_file.split('.lingo')
            if (f'{".ignore"}') in rest:
                continue
            run_test(in_src_f)

    run(["dune", "clean"])

if FAIL:
    exit(1)
