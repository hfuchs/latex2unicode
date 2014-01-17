use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'L2U',
    #ABSTRACT      => 'Test',
    LICENSE       => 'perl',
    AUTHOR        => 'Hagen Fuchs <code@hfuchs.net>',
    VERSION       => '0.3',
    EXE_FILES     => [ 'bin/latex2unicode' ],
    #VERSION_FROM => 'lib/L2U/Constants.pm'
);

