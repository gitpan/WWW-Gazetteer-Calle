use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME	 => "WWW::Gazetteer::Calle",
  VERSION_FROM => 'Calle.pm',
  PREREQ_PM    =>  {
   'LWP::UserAgent' => 0.01,
   'Test::Simple' => 0.01,
  },
  AUTHOR       => 'Leon Brocard <acme@astray.com>',
);


