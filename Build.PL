#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Module::Build;

my $build = Module::Build->new(
    module_name => 'DORCNet',
    license => 'perl',
    requires => {
    },
    extra_compiler_flags => '-std=c99',
    extra_linker_flags => '-lax25',
);

$build->create_build_script;
