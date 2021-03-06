use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'BulkSMS',
    AUTHOR              => q{Rakesh Kumar Shardiwal <rakesh.shardiwal@gmail.com>},
    VERSION_FROM        => 'lib/BulkSMS.pm',
    ABSTRACT_FROM       => 'lib/BulkSMS.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'     => 0,
        'Moose'          => 0,
        'LWP::UserAgent' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'BulkSMS-*' },
);
