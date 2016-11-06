
# using Plack::Util;
# using Plack::Loader;

{ package rise::lib::web; use rise::core::object::namespace;   

    { package rise::lib::web::route; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1105052847"; sub VERSION {"2016.1105052847"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-setRoute  public-function-getRoute  public-var-routes}} 

         sub routes ():lvalue; no warnings; *__routes__ = sub ():lvalue {  my $self = shift; $self->{'routes'} }; *routes = sub ():lvalue {  $__RISE_SELF__->{'routes'} }; use warnings;  routes = { 'GET' => [], 'POST' => [], 'PUT' => [], 'DELETE' => [] };

        { package rise::lib::web::route::setRoute; use rise::core::object::function;  sub setRoute {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = $_[0]; my $rmeth; no warnings; sub rmeth ():lvalue; *rmeth = sub ():lvalue { $rmeth }; use warnings; my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings;  ($rmeth,$objref) = ($_[1],$_[2]); 
            __RISE_PUSH $self->routes->{$rmeth}, [$objref];
            return $self->routes->{$rmeth};
        }}

        { package rise::lib::web::route::getRoute; use rise::core::object::function;  sub getRoute {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = $_[0];  
            # self.dmsg(self);
            my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings; 
            # self.apptrue             = 0;
            { my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { $r }; use warnings;  foreach (@ {($self->routes->{$self->env->{'REQUEST_METHOD'}})}) { $r = $_;
                if ($self->env->{'REQUEST_URI'} =~ m{^(?:$r->[0])$}sx) {
                    $objref = $r->[1];
                    # self.apptrue                = 1;
                    last;
                };
            }}
            return $objref;
        }}

    }

}

1;