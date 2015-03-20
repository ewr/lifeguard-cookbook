name             "lifeguard"
maintainer       "Eric Richardson"
maintainer_email "e@ewr.is"
license          "BSD"
source_url       "https://github.com/ewr/lifeguard-cookbook"
issues_url       "https://github.com/ewr/lifeguard-cookbook/issues"
description      "Installs Lifeguard process runner"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.3"

depends "nodejs"
depends "runit"