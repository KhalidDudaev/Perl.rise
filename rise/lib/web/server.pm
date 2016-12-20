
use Plack::Util;
use Plack::Loader;

{ package rise::lib::web; use rise::core::object::namespace;   
    { package rise::lib::web::server; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header  private-var-header  private-var-html  public-var-env}} 
         sub header ():lvalue; *__header__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); my $self = shift; $self->{'header'} }; *header = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); $__RISE_SELF__->{'header'} };  
         sub html ():lvalue; *__html__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); my $self = shift; $self->{'html'} }; *html = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); $__RISE_SELF__->{'html'} };  
         sub env ():lvalue; *__env__ = sub ():lvalue {  my $self = shift; $self->{'env'} }; *env = sub ():lvalue {  $__RISE_SELF__->{'env'} };   env = {};

        { package rise::lib::web::server::app2psgi; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub app2psgi {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings;  ($route) = ($_[0]); 
            # var env = self.env;

            my $psgi_app; no warnings; sub psgi_app ():lvalue; *psgi_app = sub ():lvalue { $psgi_app }; use warnings;  $psgi_app = sub { return ACODE00001($self, @_); { package rise::lib::web::server::app2psgi::ACODE00001; use rise::core::object::function; sub __function__ { __PACKAGE__ }  sub ACODE00001 { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'ACODE00001') unless (caller eq 'rise::lib::web::server::app2psgi' || caller =~ m/^rise::lib::web::server::app2psgi\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $env; no warnings; sub env ():lvalue; *env = sub ():lvalue { $env }; use warnings; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  ($env,$args) = ($_[0],$_[1]);
                $self->header->{'status'}      = 404;
                $self->header->{'type'}        = 'text/html';
                # self.html                   = self.file.read('C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\web\err404.tmpl');
                $self->html                   = $self->template('C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\web\err4040.tmpl', { 'errno' => 404, 'errmsg' => 'page not found' });
                $self->env               		= $env;
                $self->args                   = $args;

                my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings;  $objref = $self->route->getRoute;
				my $code; no warnings; sub code ():lvalue; *code = sub ():lvalue { $code }; use warnings;  $code = $objref->[1];
				my $coderef; no warnings; sub coderef ():lvalue; *coderef = sub ():lvalue { $coderef }; use warnings;  $coderef = ref $code;
				my $rparamArr; no warnings; sub rparamArr ():lvalue; *rparamArr = sub ():lvalue { $rparamArr }; use warnings;  $rparamArr = $objref->[2];
				my $rparamHash; no warnings; sub rparamHash ():lvalue; *rparamHash = sub ():lvalue { $rparamHash }; use warnings;  $rparamHash = $objref->[3];

				# self.dmsg(dump rparamHash);
				# self.dmsg(dump self.rparam);
				# var routeData				= [$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15];

                if ($objref){
                    $self->header->{'status'}      = 200;
                    $self->html                   = $code->($rparamHash, $rparamArr) if $coderef eq 'CODE';
                    $self->html                   = $code->controller($rparamHash, $rparamArr) if $coderef ne 'CODE' && __RISE_MATCH $coderef =~ m/(?:[^\d][a-zA-Z0-9_](?:\:\:)?)+/;
                }

                return [$self->header->{'status'}, ['Content-Type' => $self->header->{'type'}], [$self->html]];
            }}};

            return $psgi_app;
        }}

        { package rise::lib::web::server::start; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub start {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings;  ($route) = ($_[0]); 
            return $self->start_psgi($self->app2psgi($route));
        }}

        { package rise::lib::web::server::start_psgi; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub start_psgi {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $psgi_app; no warnings; sub psgi_app ():lvalue; *psgi_app = sub ():lvalue { $psgi_app }; use warnings;  ($psgi_app) = ($_[0]); 
            return Plack::Loader->auto->run($psgi_app);
        }}

        { package rise::lib::web::server::set_header; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub set_header {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $header; no warnings; sub header ():lvalue; *header = sub ():lvalue { $header }; use warnings;  ($header) = ($_[0]); 
            $self->header         = $header;
            return $self->header;
        }}

    }
}

1;