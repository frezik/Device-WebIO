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

sub digital_pin_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );

    my $count;
    if( $obj->does( 'Device::WebIO::Device::DigitalInput' ) ) {
        $count = $obj->input_pin_count;
    }
    elsif( $obj->does( 'Device::WebIO::Device::DigitalOutput' ) ) {
        $count = $obj->output_pin_count;
    }

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
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    return $obj->pwm_bit_resolution;
}

sub pwm_max_int
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    $self->_role_check( $obj, 'PWM' );
    return $obj->pwm_max_int;
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
