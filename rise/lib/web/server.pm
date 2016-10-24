
use Plack::Util;
use Plack::Loader;

{ package rise::lib::web; use rise::core::object::namespace;   
    { package rise::lib::web::server; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1024131219"; sub VERSION {"2016.1024131219"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header  private-var-header  private-var-html  public-var-env  public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header    public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header    public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header    public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header     public-function-app2psgi  public-function-start  public-function-start_psgi  public-function-set_header   }} 
         sub header ():lvalue; no warnings; *__header__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); my $self = shift; $self->{'header'} }; *header = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); $__RISE_SELF__->{'header'} }; use warnings; 
         sub html ():lvalue; no warnings; *__html__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); my $self = shift; $self->{'html'} }; *html = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web::server' || caller =~ m/^rise::lib::web::server\b/o); $__RISE_SELF__->{'html'} }; use warnings; 
         sub env ():lvalue; no warnings; *__env__ = sub ():lvalue {  my $self = shift; $self->{'env'} }; *env = sub ():lvalue {  $__RISE_SELF__->{'env'} }; use warnings;  env = {};

        { package rise::lib::web::server::app2psgi; use rise::core::object::function;  sub app2psgi {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings;  ($self,$route) = ($_[0],$_[1]); 
            # var env = self.env;

            my $psgi_app; no warnings; sub psgi_app ():lvalue; *psgi_app = sub ():lvalue { $psgi_app }; use warnings;  $psgi_app = sub { return ACODE00027(__PACKAGE__, @_); { package rise::lib::web::server::app2psgi::ACODE00027; use rise::core::object::function; sub ACODE00027 { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'ACODE00027') unless (caller eq 'rise::lib::web::server::app2psgi' || caller =~ m/^rise::lib::web::server::app2psgi\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $env; no warnings; sub env ():lvalue; *env = sub ():lvalue { $env }; use warnings; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  ($self,$env,$args) = ($_[0],$_[1],$_[2]);
                $self->header->{'status'}      = 404;
                $self->header->{'type'}        = 'text/html';
                # self.html                   = self.file.read('C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\web\err404.tmpl');
                $self->html                   = $self->template('C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\web\err4040.tmpl', { 'errno' => 404, 'errmsg' => 'page not found' });
                $self->self->env               = $env;
                $self->args                   = $args;

                my $objref; no warnings; sub objref ():lvalue; *objref = sub ():lvalue { $objref }; use warnings;  $objref = $self->route->getRoute;

                if ($self->apptrue){
                    $self->header->{'status'}      = 200;
                    $self->html                   = $objref->() if ref $objref eq 'CODE';
                    $self->html                   = $objref->app if ref $objref ne 'CODE';
                }

                return [$self->header->{'status'}, ['Content-Type' => $self->header->{'type'}], [$self->html]];
            }}};

            return $psgi_app;
        }}

        { package rise::lib::web::server::start; use rise::core::object::function;  sub start {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings;  ($self,$route) = ($_[0],$_[1]); 
            return $self->start_psgi($self->app2psgi($route));
        }}

        { package rise::lib::web::server::start_psgi; use rise::core::object::function;  sub start_psgi {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $psgi_app; no warnings; sub psgi_app ():lvalue; *psgi_app = sub ():lvalue { $psgi_app }; use warnings;  ($self,$psgi_app) = ($_[0],$_[1]); 
            return Plack::Loader->auto->run($psgi_app);
        }}

        { package rise::lib::web::server::set_header; use rise::core::object::function;  sub set_header {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $header; no warnings; sub header ():lvalue; *header = sub ():lvalue { $header }; use warnings;  ($self,$header) = ($_[0],$_[1]); 
            $self->header         = $header;
            return $self->header;
        }}

    }
}

1;