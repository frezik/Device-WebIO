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
package Device::WebIO;

# ABSTRACT: Duct Tape for the Internet of Things
use v5.12;
use Moo;
use namespace::clean;
use Device::WebIO::Exceptions;

has '_device_by_name' => (
    is      => 'ro',
    default => sub {{
    }},
);


sub register
{
    my ($self, $name, $device) = @_;
    $self->_device_by_name->{$name} = $device;
    return 1;
}


sub set_as_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalInput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalInput' );
    $obj->set_as_input( $pin );
    return 1;
}

sub set_as_output
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalOutput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalOutput' );
    $obj->set_as_output( $pin );
    return 1;
}

sub is_set_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalInput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalInput' );
    return $obj->is_set_input( $pin );
}

sub is_set_output
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalOutput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalOutput' );
    return $obj->is_set_output( $pin );
}

sub digital_input_pin_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalInput' );
    my $count = $obj->input_pin_count;
    return $count;
}

sub digital_output_pin_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalOutput' );
    my $count = $obj->output_pin_count;
    return $count;
}

sub digital_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalInput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalInput' );
    return $obj->input_pin( $pin );
}

sub digital_input_port
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalInput' );
    return $obj->input_port;
}

sub digital_output_port
{
    my ($self, $name, $out) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalOutput' );
    $obj->output_port( $out );
    return 1;
}

sub digital_output
{
    my ($self, $name, $pin, $val) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'DigitalOutput' );
    $self->_pin_count_check( $name, $obj, $pin, 'DigitalOutput' );
    $obj->output_pin( $pin, $val );
    return 1;
}

sub adc_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    return $obj->adc_pin_count;
}

sub adc_resolution
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    return $obj->adc_bit_resolution( $pin );
}

sub adc_max_int
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    return $obj->adc_max_int( $pin );
}

sub adc_volt_ref
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    return $obj->adc_volt_ref( $pin );
}

sub adc_input_int
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    $self->_pin_count_check( $name, $obj, $pin, 'ADC' );
    return $obj->adc_input_int( $pin );
}

sub adc_input_float
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    $self->_pin_count_check( $name, $obj, $pin, 'ADC' );
    return $obj->adc_input_float( $pin );
}

sub adc_input_volts
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'ADC' );
    $self->_pin_count_check( $name, $obj, $pin, 'ADC' );
    return $obj->adc_input_volts( $pin );
}

sub pwm_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    return $obj->pwm_pin_count;
}

sub pwm_resolution
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    return $obj->pwm_bit_resolution( $pin );
}

sub pwm_max_int
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    return $obj->pwm_max_int( $pin );
}

sub pwm_output_int
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    $self->_pin_count_check( $name, $obj, $pin, 'PWM' );
    return $obj->pwm_output_int( $pin, $value );
}

sub pwm_output_float
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    $self->_pin_count_check( $name, $obj, $pin, 'PWM' );
    return $obj->pwm_output_float( $pin, $value );
}

sub vid_channels
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_channels;
}

sub vid_width
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_width( $pin );
}

sub vid_height
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_height( $pin );
}

sub vid_fps
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_fps( $pin );
}

sub vid_kbps
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_kbps( $pin );
}

sub vid_set_width
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_set_width( $pin, $value );
}

sub vid_set_height
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_set_height( $pin, $value );
}

sub vid_set_fps
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_set_fps( $pin, $value );
}

sub vid_set_kbps
{
    my ($self, $name, $pin, $value) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    $self->_role_check( $obj, 'VideoOutput' );
    return $obj->vid_set_kbps( $pin, $value );
}

sub vid_allowed_content_types
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    return $obj->vid_allowed_content_types( $pin );
}

sub vid_stream
{
    my ($self, $name, $pin, $type) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_pin_count_check( $name, $obj, $pin, 'VideoOutput' );
    return $obj->vid_stream( $pin, $type );
}


sub _get_obj
{
    my ($self, $name) = @_;
    my $obj = $self->_device_by_name->{$name};
    return $obj;
}

sub _pin_count_check
{
    my ($self, $name, $obj, $pin, $type) = @_;
    my $pin_count = $self->_pin_count_for_obj( $obj, $type );

    if( $pin_count <= $pin ) {
        Device::WebIO::PinDoesNotExistException->throw(
            message => "Asked for $type pin $pin, but device $name"
                . " only has $pin_count pins",
        );
    }

    return 1;
}

sub _pin_count_for_obj
{
    my ($self, $obj, $type) = @_;

    my $count;
    if( $type eq 'DigitalInput' &&
        $obj->does( 'Device::WebIO::Device::DigitalInput' ) ) {
        $count = $obj->input_pin_count;
    }
    elsif( $type eq 'DigitalOutput' &&
        $obj->does( 'Device::WebIO::Device::DigitalOutput' ) ) {
        $count = $obj->output_pin_count;
    }
    elsif( $type eq 'ADC' &&
        $obj->does( 'Device::WebIO::Device::ADC' ) ) {
        $count = $obj->adc_pin_count;
    }
    elsif( $type eq 'PWM' &&
        $obj->does( 'Device::WebIO::Device::PWM' ) ) {
        $count = $obj->pwm_pin_count;
    }
    elsif( $type eq 'VideoOutput' &&
        $obj->does( 'Device::WebIO::Device::VideoOutput' ) ) {
        $count = $obj->vid_channels;
    }

    return $count;
}

sub _role_check
{
    my ($self, $obj, $want_type) = @_;
    my $full_want_type = 'Device::WebIO::Device::' . $want_type;

    if(! $obj->does( $full_want_type ) ) {
        Device::WebIO::FunctionNotSupportedException->throw( message =>
            "Object of type " . ref($obj)
                . " does not do the $full_want_type role"
        );
    }

    return 1;
}


1;
__END__


=head1 NAME

  Device::WebIO - Duct Tape for the Internet of Things

=head1 SYNOPSIS

    my $webio = Device::WebIO->new;
    $webio->register( 'foo', $dev ); # Register a device with the name 'foo'
    
    # Input pin 0 on device registered with the name 'foo'
    my $in_value = $webio->digital_input( 'foo', 0 );
    # Output pin 0 on device registered with the name 'foo'
    $webio->digital_input( 'foo', 0, $in_value );

=head1 DESCRIPTION

Device::WebIO provides a standardized interface for accessing GPIO, 
Analog-to-Digital, Pulse Width Modulation, and many other devices.  Drivers 
are available for the Raspberry Pi, PCDuino, Arduino (via Firmata attached 
over USB), and many others in the future.

=head1 METHODS

=head3 new

Constructor.

=head3 register

  register( $name, $obj );

Register a driver object with the given name.  The object must do the 
c<Device::WebIO::Device> role.

=head2 Input

=head3 set_as_input

  set_as_input( $name, $pin );

Set the given pin as input.

=head3 is_set_input

  is_set_input( $name, $pin );

Check if the given pin is already set as input.

=head3 digital_input_pin_count

  digital_input_pin_count( $name );

Returns how many input pins there are for this device.

=head3 digital_input

  digital_input( $name, $pin );

Returns the input status of the given pin.  1 for on, 0 for off.

=head3 digital_input_port

  digital_input_port( $name );

Returns an integer with each bit representing the on or off status of the 
associated pin.

=head2 Output

=head3 set_as_output

  set_as_output( $name, $pin );

Set the given pin as output.

=head3 is_set_output

  is_set_output( $name, $pin );

Check if the given pin is set as output.

=head3 digital_output_pin_count

  digital_output_pin_count( $name );

Returns the number of output pins.

=head3 digital_output

  digital_output( $name, $pin, $value );

Sets the value of the output for the given pin.  1 for on, 0 for off.

=head3 digital_output_port

  digital_output_port( $name, $int );

Sets the value of all output pins.  Each bit of C<$int> corresponds to a pin.

=head2 Analog-to-Digital

=head3 adc_count

  adc_count( $name );

Returns the number of ADC pins.

=head3 adc_resolution

  adc_resolution( $name, $pin );

Returns the number of bits of resolution for the given pin.

=head3 adc_max_int

  adc_max_int( $name, $pin );

Returns the max integer value for the given pin.

=head3 adc_volt_ref

  adc_volt_ref( $name, $pin );

Returns the voltage reference for the given pin.  All ADC values are scaled 
between 0 (ground) and the volt ref.

=head3 adc_input_int

  adc_input_int( $name, $pin );

Return the ADC integer input value.

=head3 adc_input_float

  adc_input_float( $name, $pin );

Return the ADC floating point input value.  The value will be between 0.0 and 
1.0.

=head3 adc_input_volts

  adc_input_volts( $name, $pin );

Return the voltage level of the given pin.  This will be between 0.0 (ground) 
and the volt ref.

=head2 PWM

=head3 pwm_count

  pwm_count( $name );

Return the number of PWM pins.

=head3 pwm_resolution

  pwm_resolution( $name, $pin );

Return the number of bits of resolution for the given PWM pin.

=head3 pwm_max_int

  pwm_max_int( $name, $pin );

Return the max int value for the given PWM ping.

=head3 pwm_output_int

  pwm_output_int( $name, $pin, $value );

Set the value of the given PWM pin.

=head3 pwm_output_float

  pwm_output_float( $name, $pin, $value );

Set the value of the given PWM pin with a floating point value between 0.0 
and 1.0.

=head2 Video

=head3 vid_channels

  vid_channels( $name );

Get the number of video channels.

=head3 vid_width

  vid_width( $name, $channel );

Return the width of the video channel.

=head3 vid_height

  vid_height( $name, $channel );

Return the height of the video channel.

=head3 vid_fps

  vid_fps( $name, $channel );

Return the Frames Per Second of the video channel.

=head3 vid_kbps

  vid_kbps( $name, $channel );

Return the bitrate of the video channel.

=head3 vid_set_width

  vid_set_width( $name, $channel, $width );

Set the width of the video channel.

=head3 vid_set_height

  vid_set_height( $name, $channel, $height );

Set the height of the video channel.

=head3 vid_allowed_content_types

  vid_allowed_content_types( $name, $channel );

Returns a list of MIME types allowed for the given video channel.

=head3 vid_stream

  vid_stream( $name, $name, $pin, $type );

Returns a filehandle for streaming the video channel.  C<$type> is one of the 
MIME types returned by C<vid_allowed_content_types()>.

=head1 SEE ALSO

=head1 LICENSE

Copyright (c) 2014  Timm Murray
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are 
permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of 
      conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials 
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS 
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
