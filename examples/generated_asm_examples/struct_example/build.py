#!/usr/bin/python3
import os
import sys

sources = []
binary_name = "struct"
assembler = "yasm"
assembler_options = ""
debug_assembler_options = ""
linker = "gcc"
linker_options = ""

if sys.platform.startswith("linux"):
    assembler_options = "-felf64 -fPIE"
    debug_assembler_options = "-felf64 -fPIE -g dwarf2"
    sources = ["struct_linux.asm"]
elif sys.platform == "darwin":
    assembler = "nasm"  # Use nasm because of the better debugging support
    assembler_options = "-fmacho64"
    debug_assembler_options = "-g -fmacho64"
    sources = ["struct_macos.asm"]
else:
    exit(1)


def make_name(file, extension):
    for i in range(len(file)):
        if file[i] == '.':
            return file[0:i] + '.' + extension

    return file + extension


def assemble(file, debug):
    out_name = make_name(file, "o")
    if os.system("{} {} -o {} {}".format(assembler, file,
                                         out_name, debug_assembler_options if debug else assembler_options)) != 0:
        exit(1)

    return out_name


def link_files(files, binary_name):
    if os.system("{} {} -o {} {}".format(linker, " ".join(files),
                                         binary_name, linker_options)) != 0:
        exit(1)


def clean(sources):
    for file in sources:
        name = make_name(file, "o")
        if os.path.exists(name):
            print("Deleting: \"" + name + "\"")
            os.remove(name)

    if os.path.exists(binary_name):
        print("Deleting: \"" + binary_name + "\"")
        os.remove(binary_name)


def run():
    exit(os.system("./{}".format(binary_name)))


def build(debug=False):
    objects = []

    for file in sources:
        objects += [assemble(file, debug)]

    link_files(objects, binary_name)


if __name__ == "__main__":
    if len(sys.argv) > 2:
        print("Invalid args.")
        exit(1)

    if len(sys.argv) == 2:
        if sys.argv[1] == "clean":
            clean(sources)
            print("Cleaned")
            exit(0)
        elif sys.argv[1] == "run":
            build()
            run()
            exit(0)
        elif sys.argv[1] == "debug":
            build(True)
            exit(0)
        else:
            print("Invalid args.")
            exit(1)
    else:
        build()
