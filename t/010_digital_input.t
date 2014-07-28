# Copyright (c) 2014  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
use Test::More tests => 12;
use v5.12;
use lib 't/lib/';
use Device::WebIO;
use MockDigitalInput;

my $input = MockDigitalInput->new({
    input_pin_count => 8,
});
ok( $input->does( 'Device::WebIO::Device' ), "Does Device role" );
ok( $input->does( 'Device::WebIO::Device::DigitalInput' ),
    "Does DigitalInput role" );

my $webio = Device::WebIO->new;
$webio->register( 'foo', $input );

$webio->set_as_input( 'foo', 0 );
$webio->set_as_input( 'foo', 1 );
ok( $input->mock_is_set_input( 0 ), "Pin 0 set as input" );
ok( $input->mock_is_set_input( 1 ), "Pin 1 set as input" );
ok(!$input->mock_is_set_input( 2 ), "Pin 2 not set as input" );

$input->mock_set_input( 0, 0 );
$input->mock_set_input( 1, 1 );
ok(!$webio->digital_input( 'foo', 0 ), "Input 0 on pin 0" );
ok( $webio->digital_input( 'foo', 1 ), "Input 1 on pin 1" );

cmp_ok( $webio->digital_input_pin_count( 'foo' ), '==', 8,
    "Fetch pin count" );

$input->mock_set_input( 4, 1 );
cmp_ok( $webio->digital_input_port( 'foo' ), '==', 0b00010010, 
    "Read whole port" );


eval {
    $webio->set_as_input( 'foo', 10 );
};
ok( ($@ && Device::WebIO::PinDoesNotExistException->caught( $@ )),
    "Caught exception for using too high a pin for set_as_input()" );
eval {
    $webio->digital_input( 'foo', 10 );
};
ok( ($@ && Device::WebIO::PinDoesNotExistException->caught( $@ )),
    "Caught exception for using too high a pin for digital_input()" );

eval {
    $webio->digital_output( 'foo', 0 );
};
ok( ($@ && Device::WebIO::FunctionNotSupportedException->caught( $@ )),
    "Caught exception for using an output function on an input-only object"
);
