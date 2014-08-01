package Device::WebIO::Device::VideoOutput;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'vid_channels';
requires 'vid_height';
requires 'vid_width';
requires 'vid_fps';
requires 'vid_kbps';
requires 'vid_set_height';
requires 'vid_set_width';
requires 'vid_set_fps';
requires 'vid_set_kbps';
requires 'vid_allowed_content_types';
requires 'vid_stream';

1;
__END__

