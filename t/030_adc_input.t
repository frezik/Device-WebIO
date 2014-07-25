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
use Test::More tests => 17;
use v5.12;
use lib 't/lib/';
use Device::WebIO;
use MockADCInput;


my $input = MockADCInput->new({
    adc_max_int        => 255,
    adc_bit_resolution => 8,
    adc_volt_ref       => 5.0,
    adc_pin_count      => 8,
});
ok( $input->does( 'Device::WebIO::Device' ), "Does Device role" );
ok( $input->does( 'Device::WebIO::Device::ADC' ), "Does ADC role" );

my $webio = Device::WebIO->new;
$webio->register( 'foo', $input );

cmp_ok( $webio->adc_count( 'foo' ),      '==', 8,   "Pin count" );
cmp_ok( $webio->adc_resolution( 'foo' ), '==', 8,   "Bit resolution" );
cmp_ok( $webio->adc_max_int( 'foo' ),    '==', 255, "Max int" );
cmp_ok( $webio->adc_volt_ref( 'foo' ),   '==', 5.0, "Volt reference" );

$input->mock_set_input( 0, 255 );
$input->mock_set_input( 1, 0 );
$input->mock_set_input( 2, 127 );
cmp_ok( $webio->adc_input_int( 'foo', 0 ), '==', 255, "ADC pin 0 set" );
cmp_ok( $webio->adc_input_int( 'foo', 1 ), '==', 0,   "ADC pin 1 set" );
cmp_ok( $webio->adc_input_int( 'foo', 2 ), '==', 127, "ADC pin 2 set" );

cmp_ok( $webio->adc_input_float( 'foo', 0 ), '==', 1.0, "ADC pin 0 float" );
cmp_ok( $webio->adc_input_float( 'foo', 2 ), '==', 127 / 255,
    "ADC pin 2 float" );

cmp_ok( $webio->adc_input_volts( 'foo', 0 ), '==', 5.0, "ADC pin 0 volts" );
cmp_ok( $webio->adc_input_volts( 'foo', 2 ), '==', (127 / 255) * 5.0,
    "ADC pin 2 volts" );


eval {
    $webio->adc_input_int( 'foo', 10 );
};
ok( ($@ && Device::WebIO::PinDoesNotExistException->caught( $@ )),
    "Caught exception for using too high a pin for adc_input_int()" );

eval {
    $webio->adc_input_float( 'foo', 10 );
};
ok( ($@ && Device::WebIO::PinDoesNotExistException->caught( $@ )),
    "Caught exception for using too high a pin for adc_input_float()" );

eval {
    $webio->adc_input_volts( 'foo', 10 );
};
ok( ($@ && Device::WebIO::PinDoesNotExistException->caught( $@ )),
    "Caught exception for using too high a pin for adc_input_volts()" );

eval {
    $webio->digital_output( 'foo', 0 );
};
ok( ($@ && Device::WebIO::FunctionNotSupportedException->caught( $@ )),
    "Caught exception for using a digital output function on an"
        . " adc-only object"
);
