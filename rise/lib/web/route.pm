
# using Plack::Util;
# using Plack::Loader;

{ package rise::lib::web; use rise::core::object::namespace;   

    { package rise::lib::web::route; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{public-function-setRoute  public-function-getRoute  private-function-routeParse  public-var-routes}} 

         sub routes ():lvalue; *__routes__ = sub ():lvalue {  my $self = shift; $self->{'routes'} }; *routes = sub ():lvalue {  $__RISE_SELF__->{'routes'} };   routes = { 'GET' => [], 'POST' => [], 'PUT' => [], 'DELETE' => [] };

        { package rise::lib::web::route::setRoute; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub setRoute {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $rmeth; no warnings; sub rmeth ():lvalue; *rmeth = sub ():lvalue { $rmeth }; use warnings; my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings;  ($rmeth,$objref) = ($_[0],$_[1]);  #DOC: привязывает паттерн роута к коду или к объекту с методом "controller" и сохраняет их.

			#doc: setRoute sdfksdflksjdlfsjdfjlk
			my $nn; no warnings; sub nn ():lvalue; *nn = sub ():lvalue { $nn }; use warnings;  $nn = 1;

			$objref->[0]					= $self->routeParse($objref->[0]);
            __RISE_PUSH $self->routes->{$rmeth}, [$objref];

			# self.dmsg(objref.[0]);

            return $self->routes->{$rmeth};
        }}

        { package rise::lib::web::route::getRoute; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub getRoute {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;   #DOC: сравнивает роут с паттерном и при совпадении возвращает массив содержащий паттерн, код и если это предусмотренно шаблоном, данные из строки запроса.
            my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings; 
			my $reqmeth; no warnings; sub reqmeth ():lvalue; *reqmeth = sub ():lvalue { $reqmeth }; use warnings;  $reqmeth = $self->env->{'REQUEST_METHOD'};
			my $requri; no warnings; sub requri ():lvalue; *requri = sub ():lvalue { $requri }; use warnings;  $requri = $self->env->{'REQUEST_URI'};

            { my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { $r }; use warnings;  foreach (@ {($self->routes->{$reqmeth})}) { $r = $_;
				# local %+;
                if (__RISE_MATCH $requri =~ m{^(?:$r->[0])$}gsx) {
					$r->[2]				= clone [$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15];
					$r->[3]				= clone \%+;
					# self.dmsg(dump r.[3]);
                    $objref = $r;
                    last;
                };
            }}
            return $objref;
        }}

		{ package rise::lib::web::route::routeParse; use rise::core::object::function; sub __function__ { __PACKAGE__ }  sub routeParse { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'routeParse') unless (caller eq 'rise::lib::web::route' || caller =~ m/^rise::lib::web::route\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings;  ($route) = ($_[0]); 
			my $nn; no warnings; sub nn ():lvalue; *nn = sub ():lvalue { $nn }; use warnings;  $nn = 1;
			my $stat; no warnings; sub stat ():lvalue; *stat = sub ():lvalue { $stat }; use warnings;  $stat = '';

			$route					=~ s/\*/'(?<q'. $nn++ .'>.*?)'/gsxe;

			$route					=~ s/
				\:(?<name>(?!\d)[a-zA-Z0-9]+)(?:\[(?<data>.*?)\])?
			/
				my $data			= '.*?';
				$data = $+{data}						if $+{data};
				$data = __function__->codedata($data)	if $data;
				'(?<'.$+{name}.'>'.$data.')';
			/gsxe;

			return $route;

			{ package rise::lib::web::route::routeParse::codedata; use rise::core::object::function; sub __function__ { __PACKAGE__ }  sub codedata { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'codedata') unless (caller eq 'rise::lib::web::route::routeParse' || caller =~ m/^rise::lib::web::route::routeParse\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($data) = ($_[0]); 
				$data				=~ s/a/[a-zA-Z]/gsx;
				$data				=~ s/d/\\d/gsx;
				$data				=~ s/
					(\d)(?:\-(\d))?
				/
					my $to = '';
					$to = ",$2" if $2;
					'{'.$1.$to.'}'
				/gsxe;

				return $data;
			}}
		}}

    }

}

1;