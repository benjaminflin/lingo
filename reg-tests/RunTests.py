from os import listdir, getcwd
import argparse
import subprocess

cwd = f'{getcwd()}/reg-tests'
parser = argparse.ArgumentParser(
    description="Runs regression tests for lingo files")
parser.add_argument("-s", "--src-file", default=None)
parser.add_argument("-d", "--src-dir", default=f'{cwd}/src')
parser.add_argument("-o", "--diff-dir", default=f'{cwd}/diff')
parser.add_argument("-ll", "--llvm-dir", default=f'{cwd}/llvm')
parser.add_argument("-asm", "--asm-dir", default=f'{cwd}/asm')
parser.add_argument("-ex", "--exec-dir", default=f'{cwd}/exec')
parser.add_argument("-out", "--out-dir", default=f'{cwd}/out')
parser.add_argument("-lib", default=f'{cwd}/src/lib.c')
args = parser.parse_args()

diff_dir = args.diff_dir
in_src_file = args.src_file
src_dir = args.src_dir
llvm_dir = args.llvm_dir
asm_dir = args.asm_dir
exec_dir = args.exec_dir
out_dir = args.out_dir
lib = args.lib


def run(args, input=None):
    proc = subprocess.run(args, capture_output=True)
    args, returncode, stdout, stderr = \
        args, proc.returncode, proc.stdout, proc.stderr
    if returncode != 0:
        print(f'{" ".join(args)} returned {returncode}')
        print(f'STDOUT: \n {stdout}')
        print(f'STDERR: \n {stderr}')
        raise RuntimeError(args, returncode, stdout, stderr)
    return stdout, stderr


def log(msg):
    print(msg)
    with open(f'{cwd}/log.txt', 'a') as file:
        file.write(msg)


def get_llvm(src):
    log("---GENERATING LLVM---")
    stdout, stderr = run(
        ["dune", "exec", f'./src/lingo.exe', f'{src_dir}/{src}'])
    return stdout


def build_asm(llvm):
    log("---GENERATING ASM---")
    stdout, stderr = run(["llc"], llvm)
    return stdout


def build_exec(asm):
    log("---BUILDING EXEC---")
    stdout, stderr = run(["gcc", "-no-pie", asm, lib, "-o", "/dev/stdout"])
    return stdout


def run_exec(execu):
    log("---RUNNING EXEC---")
    stdout, stderr = run([execu])
    return stdout


def diff_output(src, out):
    log("---DIFFING OUTPUT---")
    stdout, stderr = run(["diff", f'{out_dir}/{src}', f'<(echo {out})'])
    return stdout


def run_test(src_file):
    llvm = get_llvm(f'{src_file}.lingo')
    with open(f'{llvm_dir}/{src_file}.llvm', 'wb') as file:
        file.write(llvm)

    asm = build_asm(llvm)
    with open(f'{asm_dir}/{src_file}.s', 'wb') as file:
        file.write(asm)

    execu = build_exec(asm)
    with open(f'{exec_dir}/{src_file}.exe', 'wb') as file:
        file.write(execu)

    out = run_exec(f'{exec_dir}/{src_file}')
    diff = diff_output(src_file, out)

    with open(f'{diff_dir}/{src_file}.diff', 'wb') as file:
        file.write(diff)


run(["dune", "build"])
if in_src_file:
    run_test(in_src_file)
else:
    for in_src_file in listdir(src_dir):
        run_test(in_src_file)
