package WWW::Gazetteer::Calle;
use strict;
use Carp qw(croak);
use HTTP::Cookies;
use LWP::UserAgent;

use vars qw($VERSION);
$VERSION = '0.12';

my $countries = {
  'afghanistan' => 'afghanistan',
  'af' => 'afghanistan',
  'albania' => 'albania',
  'al' => 'albania',
  'algeria' => 'algeria',
  'dz' => 'algeria',
  'andorra' => 'andorra',
  'ad' => 'andorra',
  'angola' => 'angola',
  'ao' => 'angola',
  'anguilla' => 'anguilla',
  'ai' => 'anguilla',
  'antigua and barbuda' => 'antiguaandbarbuda',
  'ag' => 'antiguaandbarbuda',
  'argentina' => 'argentina',
  'ar' => 'argentina',
  'armenia' => 'armenia',
  'am' => 'armenia',
  'ashmore and cartier islands' => 'ashmoreandcartierislands',
  # Missing ISO 3166 code for ashmore and cartier islands
  'australia' => 'australia',
  'au' => 'australia',
  'austria' => 'austria',
  'at' => 'austria',
  'azerbaijan' => 'azerbaijan',
  'az' => 'azerbaijan',
  'bahamas, the' => 'bahamasthe',
  # Missing ISO 3166 code for bahamas, the
  'bahrain' => 'bahrain',
  'bh' => 'bahrain',
  'bangladesh' => 'bangladesh',
  'bd' => 'bangladesh',
  'barbados' => 'barbados',
  'bb' => 'barbados',
  'belarus' => 'belarus',
  'by' => 'belarus',
  'belgium' => 'belgium',
  'be' => 'belgium',
  'belize' => 'belize',
  'bz' => 'belize',
  'benin' => 'benin',
  'bj' => 'benin',
  'bhutan' => 'bhutan',
  'bt' => 'bhutan',
  'bolivia' => 'bolivia',
  'bo' => 'bolivia',
  'bosnia and herzegovina' => 'bosniaandherzegovina',
  'ba' => 'bosniaandherzegovina',
  'botswana' => 'botswana',
  'bw' => 'botswana',
  'bouvet island' => 'bouvetisland',
  'bv' => 'bouvetisland',
  'brazil' => 'brazil',
  'br' => 'brazil',
  'british indian ocean territory' => 'britishindianoceanterritory',
  'io' => 'britishindianoceanterritory',
  'british virgin islands' => 'britishvirginislands',
  'vg' => 'britishvirginislands',
  'brunei' => 'brunei',
  # Missing ISO 3166 code for brunei
  'bulgaria' => 'bulgaria',
  'bg' => 'bulgaria',
  'burkina faso' => 'burkinafaso',
  'bf' => 'burkinafaso',
  'burma' => 'burma',
  # Missing ISO 3166 code for burma
  'burundi' => 'burundi',
  'bi' => 'burundi',
  'cambodia' => 'cambodia',
  'kh' => 'cambodia',
  'cameroon' => 'cameroon',
  'cm' => 'cameroon',
  'canada' => 'canada',
  'ca' => 'canada',
  'cape verde' => 'capeverde',
  'cv' => 'capeverde',
  'cayman islands' => 'caymanislands',
  'ky' => 'caymanislands',
  'central african republic' => 'centralafricanrepublic',
  'cf' => 'centralafricanrepublic',
  'chad' => 'chad',
  'td' => 'chad',
  'chile' => 'chile',
  'cl' => 'chile',
  'china' => 'china',
  'cn' => 'china',
  'clipperton island' => 'clippertonisland',
  # Missing ISO 3166 code for clipperton island
  'cocos (keeling) islands' => 'cocoskeelingislands',
  'cc' => 'cocoskeelingislands',
  'colombia' => 'colombia',
  'co' => 'colombia',
  'congo' => 'congo',
  'cg' => 'congo',
  'cook islands' => 'cookislands',
  'ck' => 'cookislands',
  'coral sea islands' => 'coralseaislands',
  # Missing ISO 3166 code for coral sea islands
  'costa rica' => 'costarica',
  'cr' => 'costarica',
  'croatia' => 'croatia',
  'hr' => 'croatia',
  'cuba' => 'cuba',
  'cu' => 'cuba',
  'cyprus' => 'cyprus',
  'cy' => 'cyprus',
  'czech republic' => 'czechrepublic',
  'cz' => 'czechrepublic',
  'côte d\'ivoire' => 'ctedivoire',
  # Missing ISO 3166 code for côte d'ivoire
  'denmark' => 'denmark',
  'dk' => 'denmark',
  'djibouti' => 'djibouti',
  'dj' => 'djibouti',
  'dominica' => 'dominica',
  'dm' => 'dominica',
  'dominican republic' => 'dominicanrepublic',
  'do' => 'dominicanrepublic',
  'ecuador' => 'ecuador',
  'ec' => 'ecuador',
  'egypt' => 'egypt',
  'eg' => 'egypt',
  'el salvador' => 'elsalvador',
  'sv' => 'elsalvador',
  'equatorial guinea' => 'equatorialguinea',
  'gq' => 'equatorialguinea',
  'eritrea' => 'eritrea',
  'er' => 'eritrea',
  'estonia' => 'estonia',
  'ee' => 'estonia',
  'ethiopia' => 'ethiopia',
  'et' => 'ethiopia',
  'europa island' => 'europaisland',
  # Missing ISO 3166 code for europa island
  'falkland islands (islas malvinas)' => 'falklandislandsislasmalvinas',
  'fk' => 'falklandislandsislasmalvinas',
  'fiji' => 'fiji',
  'fj' => 'fiji',
  'finland' => 'finland',
  'fi' => 'finland',
  'france' => 'france',
  'fr' => 'france',
  'gabon' => 'gabon',
  'ga' => 'gabon',
  'gambia, the' => 'gambiathe',
  # Missing ISO 3166 code for gambia, the
  'georgia, republic of' => 'georgiarepublicof',
  # Missing ISO 3166 code for georgia, republic of
  'germany' => 'germany',
  'de' => 'germany',
  'ghana' => 'ghana',
  'gh' => 'ghana',
  'gibraltar' => 'gibraltar',
  'gi' => 'gibraltar',
  'glorioso islands' => 'gloriosoislands',
  # Missing ISO 3166 code for glorioso islands
  'greece' => 'greece',
  'gr' => 'greece',
  'grenada' => 'grenada',
  'gd' => 'grenada',
  'guatemala' => 'guatemala',
  'gt' => 'guatemala',
  'guernsey' => 'guernsey',
  # Missing ISO 3166 code for guernsey
  'guinea' => 'guinea',
  'gn' => 'guinea',
  'guinea-bissau' => 'guineabissau',
  'gw' => 'guineabissau',
  'guyana' => 'guyana',
  'gy' => 'guyana',
  'haiti' => 'haiti',
  'ht' => 'haiti',
  'heard island and mcdonald islands' => 'heardislandandmcdonaldislands',
  'hm' => 'heardislandandmcdonaldislands',
  'honduras' => 'honduras',
  'hn' => 'honduras',
  'hong kong' => 'hongkong',
  'hk' => 'hongkong',
  'hungary' => 'hungary',
  'hu' => 'hungary',
  'iceland' => 'iceland',
  'is' => 'iceland',
  'india' => 'india',
  'in' => 'india',
  'indonesia' => 'indonesia',
  'id' => 'indonesia',
  'iran' => 'iran',
  'ir' => 'iran',
  'iraq' => 'iraq',
  'iq' => 'iraq',
  'ireland' => 'ireland',
  'ie' => 'ireland',
  'isle of man' => 'isleofman',
  # Missing ISO 3166 code for isle of man
  'israel' => 'israel',
  'il' => 'israel',
  'italy' => 'italy',
  'it' => 'italy',
  'jamaica' => 'jamaica',
  'jm' => 'jamaica',
  'japan' => 'japan',
  'jp' => 'japan',
  'jersey' => 'jersey',
  # Missing ISO 3166 code for jersey
  'jordan' => 'jordan',
  'jo' => 'jordan',
  'juan de nova island' => 'juandenovaisland',
  # Missing ISO 3166 code for juan de nova island
  'kazakhstan' => 'kazakhstan',
  'kz' => 'kazakhstan',
  'kenya' => 'kenya',
  'ke' => 'kenya',
  'kiribati' => 'kiribati',
  'ki' => 'kiribati',
  'kuwait' => 'kuwait',
  'kw' => 'kuwait',
  'kyrgyzstan' => 'kyrgyzstan',
  'kg' => 'kyrgyzstan',
  'laos' => 'laos',
  # Missing ISO 3166 code for laos
  'latvia' => 'latvia',
  'lv' => 'latvia',
  'lebanon' => 'lebanon',
  'lb' => 'lebanon',
  'lesotho' => 'lesotho',
  'ls' => 'lesotho',
  'liberia' => 'liberia',
  'lr' => 'liberia',
  'libya' => 'libya',
  'ly' => 'libya',
  'liechtenstein' => 'liechtenstein',
  'li' => 'liechtenstein',
  'lithuania' => 'lithuania',
  'lt' => 'lithuania',
  'luxembourg' => 'luxembourg',
  'lu' => 'luxembourg',
  'macau' => 'macau',
  'mo' => 'macau',
  'macedonia, the former yugoslav republic of' => 'macedoniatheformeryugoslavrepublicof',
  'mk' => 'macedoniatheformeryugoslavrepublicof',
  'madagascar' => 'madagascar',
  'mg' => 'madagascar',
  'malawi' => 'malawi',
  'mw' => 'malawi',
  'malaysia' => 'malaysia',
  'my' => 'malaysia',
  'maldives' => 'maldives',
  'mv' => 'maldives',
  'mali' => 'mali',
  'ml' => 'mali',
  'malta' => 'malta',
  'mt' => 'malta',
  'marshall islands' => 'marshallislands',
  'mh' => 'marshallislands',
  'mauritania' => 'mauritania',
  'mr' => 'mauritania',
  'mauritius' => 'mauritius',
  'mu' => 'mauritius',
  'mayotte' => 'mayotte',
  'yt' => 'mayotte',
  'mexico' => 'mexico',
  'mx' => 'mexico',
  'moldova' => 'moldova',
  'md' => 'moldova',
  'monaco' => 'monaco',
  'mc' => 'monaco',
  'mongolia' => 'mongolia',
  'mn' => 'mongolia',
  'montenegro' => 'montenegro',
  # Missing ISO 3166 code for montenegro
  'montserrat' => 'montserrat',
  'ms' => 'montserrat',
  'morocco' => 'morocco',
  'ma' => 'morocco',
  'mozambique' => 'mozambique',
  'mz' => 'mozambique',
  'namibia' => 'namibia',
  'na' => 'namibia',
  'naoero' => 'naoero',
  # Missing ISO 3166 code for naoero
  'nepal' => 'nepal',
  'np' => 'nepal',
  'netherlands' => 'netherlands',
  'nl' => 'netherlands',
  'new zealand' => 'newzealand',
  'nz' => 'newzealand',
  'nicaragua' => 'nicaragua',
  'ni' => 'nicaragua',
  'niger' => 'niger',
  'ne' => 'niger',
  'nigeria' => 'nigeria',
  'ng' => 'nigeria',
  'niue' => 'niue',
  'nu' => 'niue',
  'norfolk island' => 'norfolkisland',
  'nf' => 'norfolkisland',
  'north korea' => 'northkorea',
  'kp' => 'northkorea',
  'norway' => 'norway',
  'no' => 'norway',
  'oman' => 'oman',
  'om' => 'oman',
  'pakistan' => 'pakistan',
  'pk' => 'pakistan',
  'panama' => 'panama',
  'pa' => 'panama',
  'papua new guinea' => 'papuanewguinea',
  'pg' => 'papuanewguinea',
  'paraguay' => 'paraguay',
  'py' => 'paraguay',
  'peru' => 'peru',
  'pe' => 'peru',
  'philippines' => 'philippines',
  'ph' => 'philippines',
  'pitcairn islands' => 'pitcairnislands',
  # Missing ISO 3166 code for pitcairn islands
  'poland' => 'poland',
  'pl' => 'poland',
  'portugal' => 'portugal',
  'pt' => 'portugal',
  'qatar' => 'qatar',
  'qa' => 'qatar',
  'romania' => 'romania',
  'ro' => 'romania',
  'russia' => 'russia',
  'ru' => 'russia',
  'rwanda' => 'rwanda',
  'rw' => 'rwanda',
  'saint kitts and nevis' => 'saintkittsandnevis',
  'kn' => 'saintkittsandnevis',
  'saint lucia' => 'saintlucia',
  'lc' => 'saintlucia',
  'saint vincent and the grenadines' => 'saintvincentandthegrenadines',
  'vc' => 'saintvincentandthegrenadines',
  'samoa' => 'samoa',
  'ws' => 'samoa',
  'san marino' => 'sanmarino',
  'sm' => 'sanmarino',
  'sao tome and principe' => 'saotomeandprincipe',
  'st' => 'saotomeandprincipe',
  'saudi arabia' => 'saudiarabia',
  'sa' => 'saudiarabia',
  'senegal' => 'senegal',
  'sn' => 'senegal',
  'serbia' => 'serbia',
  # Missing ISO 3166 code for serbia
  'seychelles' => 'seychelles',
  'sc' => 'seychelles',
  'sierra leone' => 'sierraleone',
  'sl' => 'sierraleone',
  'singapore' => 'singapore',
  'sg' => 'singapore',
  'slovakia' => 'slovakia',
  'sk' => 'slovakia',
  'slovenia' => 'slovenia',
  'si' => 'slovenia',
  'solomon islands' => 'solomonislands',
  'sb' => 'solomonislands',
  'somalia' => 'somalia',
  'so' => 'somalia',
  'south africa' => 'southafrica',
  'za' => 'southafrica',
  'south georgia and the south sandwich islands' => 'southgeorgiaandthesouthsandwichislands',
  'gs' => 'southgeorgiaandthesouthsandwichislands',
  'south korea' => 'southkorea',
  'kr' => 'southkorea',
  'spain' => 'spain',
  'es' => 'spain',
  'sri lanka' => 'srilanka',
  'lk' => 'srilanka',
  'sudan' => 'sudan',
  'sd' => 'sudan',
  'suriname' => 'suriname',
  'sr' => 'suriname',
  'swaziland' => 'swaziland',
  'sz' => 'swaziland',
  'sweden' => 'sweden',
  'se' => 'sweden',
  'switzerland' => 'switzerland',
  'ch' => 'switzerland',
  'syria' => 'syria',
  'sy' => 'syria',
  'taiwan' => 'taiwan',
  'tw' => 'taiwan',
  'tajikistan' => 'tajikistan',
  'tj' => 'tajikistan',
  'tanzania' => 'tanzania',
  'tz' => 'tanzania',
  'thailand' => 'thailand',
  'th' => 'thailand',
  'togo' => 'togo',
  'tg' => 'togo',
  'tokelau' => 'tokelau',
  'tk' => 'tokelau',
  'tonga' => 'tonga',
  'to' => 'tonga',
  'trinidad and tobago' => 'trinidadandtobago',
  'tt' => 'trinidadandtobago',
  'tristan da cunha' => 'tristandacunha',
  # Missing ISO 3166 code for tristan da cunha
  'tromelin island' => 'tromelinisland',
  # Missing ISO 3166 code for tromelin island
  'tunisia' => 'tunisia',
  'tn' => 'tunisia',
  'turkey' => 'turkey',
  'tr' => 'turkey',
  'turkmenistan' => 'turkmenistan',
  'tm' => 'turkmenistan',
  'turks and caicos islands' => 'turksandcaicosislands',
  'tc' => 'turksandcaicosislands',
  'tuvalu' => 'tuvalu',
  'tv' => 'tuvalu',
  'uganda' => 'uganda',
  'ug' => 'uganda',
  'ukraine' => 'ukraine',
  'ua' => 'ukraine',
  'united arab emirates' => 'unitedarabemirates',
  'ae' => 'unitedarabemirates',
  'united kingdom' => 'unitedkingdom',
  'gb' => 'unitedkingdom',
  'uk' => 'unitedkingdom', # special case
  'uruguay' => 'uruguay',
  'uy' => 'uruguay',
  'uzbekistan' => 'uzbekistan',
  'uz' => 'uzbekistan',
  'vanuatu' => 'vanuatu',
  'vu' => 'vanuatu',
  'vatican city' => 'vaticancity',
  # Missing ISO 3166 code for vatican city
  'venezuela' => 'venezuela',
  've' => 'venezuela',
  'vietnam' => 'vietnam',
  'vn' => 'vietnam',
  'western sahara' => 'westernsahara',
  'eh' => 'westernsahara',
  'yemen' => 'yemen',
  'ye' => 'yemen',
  'zambia' => 'zambia',
  'zm' => 'zambia',
  'zimbabwe' => 'zimbabwe',
  'zw' => 'zimbabwe',
};

sub new {
  my($class) = @_;

  my $self = {};
  my $ua = LWP::UserAgent->new(
    env_proxy => 1,
    keep_alive => 1,
    timeout => 30,
  );
  $ua->agent("WWW::Gazetteer::Calle/$VERSION " . $ua->agent);

  $self->{ua} = $ua;

  bless $self, $class;
  return $self;
}

sub find {
  my($self, $city, $country) = @_;

  my $ua = $self->{ua};

  my $base_url = 'http://www.calle.com/world/';
  my $countrycode = $countries->{lc $country};
  if (not defined $countrycode) {
    ($city, $country) = ($country, $city);
    $countrycode = $countries->{lc $country};
    if (not defined $countrycode) {
      croak("WWW::Gazetteer::Calle: Country $city / $country not found");
      return;
    }
  }

  my ($prefix) = $city =~ /^(..)/;
  my $request = HTTP::Request->new('GET', $base_url . $countrycode . "/$prefix.html");
  sleep 1; # be nice to the remote server
  my $response = $ua->request($request);
	
  if (not $response->is_success) {
    croak("WWW::Gazetteer::Calle: City $city in $country not found");
    return;
  }

  my @cities;
  my $content = $response->content;
  while ($content =~ s#<tr><td><a href="http://www.calle.com/info.cgi\?lat=([\-\d\.]+)\&long=([\-\d\.]+)\&name=[^&]+\&cty=[^&]+\&alt=(\d+)">$city( City)?</a>##) {
    my($latitude, $longitude, $elevation) = ($1, $2, $3);
    $elevation = int($elevation * 0.3048);
    push @cities, {
      city => $city,
      country => $country,
      latitude => $latitude,
      longitude => $longitude,
      elevation => $elevation,
    };
  }
  return wantarray ? @cities : \@cities;
}

__END__

=head1 NAME

WWW::Gazetteer::Calle - Find location of world towns and cities

=head1 SYNOPSYS

  use WWW::Gazetteer::Calle;
  my $g = WWW::Gazetteer::Calle->new();
  my @londons = $g->find(UK => 'London');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  my $nice = $g->find("Nice", "France")->[0];
  print $nice->{city}, ", ", $nice->{elevation}, "\n";

=head1 DESCRIPTION

A gazetteer is a geographical dictionary (as at the back of an
atlas). The C<WWW::Gazetteer::Calle> module uses the information at
http://www.calle.com/world/ to return geographical location
(longitude, latitude, elevation) for towns and cities in countries in
the world.

Once you have imported the module and created a gazetteer object,
calling find($country => $town) will return a list of hashrefs with
longitude and latitude information.

  my @londons = $g->find(UK => 'London');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  # prints -0.1167, 51.5000

The hashref for London actually looks like this:

  $london = {
    longitude => "-0.1167",
    latitude  => "51.5000",
    city      => 'London',
    country   => 'UK',
    elevation => "14",
  };

The city and country values are the same as the ones you used. The
elevation is elevation above sea level in meters. The longitude and
latitude are in degrees, ranging from -180 to 180 where (0, 0) is on
the Prime Meridian and the equator.

=head1 METHODS

=head2 new()

This returns a new WWW::Gazetteer::Calle object. It currently has no
arguments:

  use WWW::Gazetteer::Calle;
  my $g = WWW::Gazetteer::Calle->new();

=head2 find()

The find method looks up geographical information and returns it to
you. It takes in a city and a country, with the recommended syntax
being ISO 3166 code and city name. However, it also tries to do what
you mean.

Note that there may be more than one town or city with that name in
the country. You will get a list of hashrefs for each town/city.

  my @londons = $g->find("UK" => "London");
  my @londons = $g->find("United Kingdom" => "London");
  my @londons = $g->find("London", "United Kingdom");

The following countries are valid (as are their ISO 3166 codes):
Afghanistan, Albania, Algeria, Andorra, Angola, Anguilla, Antigua and
Barbuda, Argentina, Armenia, Ashmore and Cartier Islands, Australia,
Austria, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados,
Belarus, Belgium, Belize, Benin, Bhutan, Bolivia, Bosnia and
Herzegovina, Botswana, Bouvet Island, Brazil, British Indian Ocean
Territory, British Virgin Islands, Brunei, Bulgaria, Burkina Faso,
Burma, Burundi, Cambodia, Cameroon, Canada, Cape Verde, Cayman
Islands, Central African Republic, Chad, Chile, China, Clipperton
Island, Cocos (Keeling) Islands, Colombia, Congo, Cook Islands, Coral
Sea Islands, Costa Rica, Croatia, Cuba, Cyprus, Czech Republic, Côte
d'Ivoire, Denmark, Djibouti, Dominica, Dominican Republic, Ecuador,
Egypt, El Salvador, Equatorial Guinea, Eritrea, Estonia, Ethiopia,
Europa Island, Falkland Islands (Islas Malvinas), Fiji, Finland,
France, Gabon, Gambia, The, Georgia, Republic of, Germany, Ghana,
Gibraltar, Glorioso Islands, Greece, Grenada, Guatemala, Guernsey,
Guinea, Guinea-Bissau, Guyana, Haiti, Heard Island and McDonald
Islands, Honduras, Hong Kong, Hungary, Iceland, India, Indonesia,
Iran, Iraq, Ireland, Isle of Man, Israel, Italy, Jamaica, Japan,
Jersey, Jordan, Juan de Nova Island, Kazakhstan, Kenya, Kiribati,
Kuwait, Kyrgyzstan, Laos, Latvia, Lebanon, Lesotho, Liberia, Libya,
Liechtenstein, Lithuania, Luxembourg, Macau, Macedonia, The Former
Yugoslav Republic of, Madagascar, Malawi, Malaysia, Maldives, Mali,
Malta, Marshall Islands, Mauritania, Mauritius, Mayotte, Mexico,
Moldova, Monaco, Mongolia, Montenegro, Montserrat, Morocco,
Mozambique, Namibia, Naoero, Nepal, Netherlands, New Zealand,
Nicaragua, Niger, Nigeria, Niue, Norfolk Island, North Korea, Norway,
Oman, Pakistan, Panama, Papua New Guinea, Paraguay, Peru, Philippines,
Pitcairn Islands, Poland, Portugal, Qatar, Romania, Russia, Rwanda,
Saint Kitts and Nevis, Saint Lucia, Saint Vincent and the Grenadines,
Samoa, San Marino, Sao Tome and Principe, Saudi Arabia, Senegal,
Serbia, Seychelles, Sierra Leone, Singapore, Slovakia, Slovenia,
Solomon Islands, Somalia, South Africa, South Georgia and the South
Sandwich Islands, South Korea, Spain, Sri Lanka, Sudan, Suriname,
Swaziland, Sweden, Switzerland, Syria, Taiwan, Tajikistan, Tanzania,
Thailand, Togo, Tokelau, Tonga, Trinidad and Tobago, Tristan da Cunha,
Tromelin Island, Tunisia, Turkey, Turkmenistan, Turks and Caicos
Islands, Tuvalu, Uganda, Ukraine, United Arab Emirates, United
Kingdom, Uruguay, Uzbekistan, Vanuatu, Vatican City, Venezuela,
Vietnam, Western Sahara, Yemen, Zambia, Zimbabwe.

Note that there may be bugs in the Calle database. Do not rely on this
module for navigation.

=head1 COPYRIGHT

Copyright (C) 2002, Leon Brocard

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=head1 AUTHOR

Leon Brocard, acme@astray.com. Based upon ideas and code by Nathan Bailey.


