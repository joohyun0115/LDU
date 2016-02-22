#!/usr/bin/perl
#
# BEAMERSCAPE Export Overlays
# Written by Jonathan Bohren 
#
# About
#   This script will export the layers from an inkscape svg file into a
#   directory with the same basename as the .svg file. The layers will be
#   exported in pdf format to preserve transparency.
#   
#   For more info, see:
#     https://github.com/jbohren/beamerscape
# 
# License
#   Copyright (c) 2013, Jonathan Bohren (jonathan.bohren@gmail.com)
#   All rights reserved.
#  
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of the beamerscape project nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#  
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#   DISCLAIMED. IN NO EVENT SHALL JONATHAN BOHREN BE LIABLE FOR ANY
#   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;

use File::Basename;
use XML::LibXML;

# Get the inkscape file name
my $inkfile = $ARGV[0];

# Parse file path
my ($inkname,$inkpath,$inksuffix) = fileparse($inkfile,".svg");

# Get the optional output path
my $outputpath = '';
if(@ARGV > 1) {
  $outputpath = $ARGV[1];
} else {
  $outputpath = $inkpath;
}

# Robust get file layers
my $file = 'files/camelids.xml';
my $parser = XML::LibXML->new();
my $tree = $parser->parse_file($inkfile);
my $root = $tree->getDocumentElement;
my @layers = $root->getElementsByTagName('g');

# Generate and touch the overlay path
my $overlay_path = join('/',$outputpath,$inkname);
`mkdir -p $overlay_path`;
`touch $overlay_path`;

# Open the tex file
my $tex_path = join('/',$overlay_path,'overlay.tex');
open (TEXFILE, ">$tex_path");

# Export the layers
print TEXFILE "%overlays!";
foreach my $layer ( @layers ) {
  # Get layer info
  my $id = $layer->getAttribute('id');
  if($layer->hasAttribute('inkscape:label')) {
    my $label = $layer->getAttribute('inkscape:label');

    # Parse overlay spec
    my $overlay_spec = "+-";

    # Get file layers
    if($label =~ m/<(.+)>/) {
      $overlay_spec = $1;
    }

    # Debug/info spew
    printf "layer id='%s' label='%s' overlay_spec='%s'\n", $id, $label, $overlay_spec;

    my $outfile = join('/',$overlay_path,$label);
    `inkscape $inkfile -z -C -i '$id' -j -A $outfile.pdf`;# --export-latex`;

    # Create tex for this layer
    printf TEXFILE "
  \% Layer \"%s\"
  \\pgfdeclareimage[width=\\paperwidth]{%s}{%s}
  \\begin{textblock}{1}(0,0)
    \\pgfuseimage<%s>{%s}
  \\end{textblock}\n", $label,$id,$outfile,$overlay_spec,$id;
  }
}

close (TEXFILE);
