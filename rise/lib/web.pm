
use Plack::Util;
use Plack::Loader;
use CGI::Carp qw/fatalsToBrowser/;
use rise::lib::fs::file;

# using web::route;
{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::web; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1017044311"; sub VERSION {"2016.1017044311"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{export:simple-function-wsay  export:simple-function-out  export:simple-function-req  export:simple-function-template  private-function-_tag  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-route  export:simple-function-get  export:simple-function-dmsg  private-function-__route_eq  private-var-file  private-var-data  export:simple-var-env  public-var-routes  private-var-out  private-var-_qobj  private-var-_tout  private-var-header  private-var-html  private-var-args  private-var-apptrue}} sub __EXPORT__ { {":all"=>[qw/wsay out req template tsay tout query start set_header route get dmsg env/],":function"=>[qw/wsay out req template tsay tout query start set_header route get dmsg/],":simple"=>[qw/wsay out req template tsay tout query start set_header route get dmsg env/],":var"=>[qw/env/],"dmsg"=>[qw/dmsg/],"env"=>[qw/env/],"get"=>[qw/get/],"out"=>[qw/out/],"query"=>[qw/query/],"req"=>[qw/req/],"route"=>[qw/route/],"set_header"=>[qw/set_header/],"start"=>[qw/start/],"template"=>[qw/template/],"tout"=>[qw/tout/],"tsay"=>[qw/tsay/],"wsay"=>[qw/wsay/],} } 

         sub file ():lvalue; no warnings; *__file__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'file'} }; *file = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'file'} }; use warnings;  file = new rise::lib::fs::file::;

         sub data ():lvalue; no warnings; *__data__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'data') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'data'} }; *data = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'data') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'data'} }; use warnings; 
         sub env ():lvalue; no warnings; *__env__ = sub ():lvalue {  my $self = shift; $self->{'env'} }; *env = sub ():lvalue {  $__RISE_SELF__->{'env'} }; use warnings;  env = {};
         sub routes ():lvalue; no warnings; *__routes__ = sub ():lvalue {  my $self = shift; $self->{'routes'} }; *routes = sub ():lvalue {  $__RISE_SELF__->{'routes'} }; use warnings;  routes = { 'GET' => [], 'POST' => [], 'UPDATE' => [], 'DELETE' => [] };
         sub out ():lvalue; no warnings; *__out__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'out') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'out'} }; *out = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'out') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'out'} }; use warnings; 
         sub _qobj ():lvalue; no warnings; *___qobj__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_qobj') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'_qobj'} }; *_qobj = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_qobj') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'_qobj'} }; use warnings;  _qobj = {};
         sub _tout ():lvalue; no warnings; *___tout__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_tout') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'_tout'} }; *_tout = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_tout') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'_tout'} }; use warnings; 
         sub header ():lvalue; no warnings; *__header__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'header'} }; *header = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'header') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'header'} }; use warnings; 
         sub html ():lvalue; no warnings; *__html__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'html'} }; *html = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'html') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'html'} }; use warnings; 
         sub args ():lvalue; no warnings; *__args__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'args') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'args'} }; *args = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'args') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'args'} }; use warnings; 
         sub apptrue ():lvalue; no warnings; *__apptrue__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'apptrue') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'apptrue'} }; *apptrue = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'apptrue') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'apptrue'} }; use warnings; 

        { package rise::lib::web::wsay; use rise::core::object::function;  sub wsay {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]||''); 
            $self->out    .= $data;
            return $self->out;
        }}

        { package rise::lib::web::out; use rise::core::object::function;  sub out {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]||''); 
            $self->out    = $data;
            return $self->out;
        }}

        # export:simple function env {
        #     return self.env;
        # }

        { package rise::lib::web::req; use rise::core::object::function;  sub req {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            $self->env->{QUERY_STRING} =~ s{\%22}{"}gsx;
            $self->env->{QUERY_STRING} =~ s{\%20}{ }gsx;
            # _env->{QUERY_STRING} =~ s{\:}{=>}gsx;
            return $self->env->{QUERY_STRING};
        }}

        { package rise::lib::web::template; use rise::core::object::function;  sub template {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings; my $params; no warnings; sub params ():lvalue; *params = sub ():lvalue { $params }; use warnings;  ($self,$tname,$params) = ($_[0],$_[1],$_[2]); 
            # self.dmsg(tname);
            my $thtml; no warnings; sub thtml ():lvalue; *thtml = sub ():lvalue { $thtml }; use warnings;  $thtml = $self->file->read($tname);

            $thtml =~ s/ \[\[(\w+)\]\] / $params->{$1}||'' /gsxe;
            # templ =~ s/(\<\/?\w+\>)/\'$1\'/gsx;
            # thtml =~ s{\.\.\.}{\$self->tsay}gsx;
            $thtml =~ s{\.\.\.\s+(.*?)\;}{\$self->tsay($1);}gsx;

            $thtml =~ s{
                \{\{(.*?)\}\}
            }{
                my $data = $1;
                eval $self->_tag($data);
                die "TEMPLATE CODE ERROR\n".$@ if $@;
                $self->tout();
            }gsxe;

            # thtml =~ s/
            #     \{\{(.*?)\}\}
            # /
            #     my $data = $1;
            #     '{{'.$self->_tag($data).'}}';
            # /gsxe;
            #
            # thtml =~ s{
            #     \{\{(.*?)\}\}
            # }{
            #     eval ($1);
            #     die "TEMPLATE CODE ERROR\n".$@ if $@;
            #     $self->tout();
            # }gsxe;

            # self.dmsg(thtml);

            return $thtml;
        }}

        { package rise::lib::web::_tag; use rise::core::object::function; sub _tag { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', '_tag') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $str; no warnings; sub str ():lvalue; *str = sub ():lvalue { $str }; use warnings;  ($self,$str) = ($_[0],$_[1]); 
            # str =~ s{\>\s*\<}{\>\.\<}gsx;
            $str =~ s{(\<\/?\w+\>)}{\'$1\'}gsx;
            # str =~ s{[^\'](\<\/?\w+\>)[^\']}{\'$1\'}gsx;
            return $str;
        }}

        { package rise::lib::web::tsay; use rise::core::object::function;  sub tsay {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]||''); 
            $self->_tout .= $data;
            return $self->_tout
        }}

        { package rise::lib::web::tout; use rise::core::object::function;  sub tout {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            my $t; no warnings; sub t ():lvalue; *t = sub ():lvalue { $t }; use warnings;  $t = $self->_tout;
            $self->_tout = '';
            return $t;
        }}

        { package rise::lib::web::query; use rise::core::object::function;  sub query {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            my $qstring; no warnings; sub qstring ():lvalue; *qstring = sub ():lvalue { $qstring }; use warnings;  $qstring = $self->env->{'QUERY_STRING'};
            $qstring =~ s{\:}{=>}gsx;
            $self->_qobj = eval $qstring;
            return $self->_qobj;
        }}

        { package rise::lib::web::start; use rise::core::object::function;  sub start {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            # self.dmsg(self);
            my $psgi_app; no warnings; sub psgi_app ():lvalue; *psgi_app = sub ():lvalue { $psgi_app }; use warnings;  $psgi_app = sub { return ACODE00001($self,@_); { package rise::lib::web::start::ACODE00001; use rise::core::object::function; sub ACODE00001 { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'ACODE00001') unless (caller eq 'rise::lib::web::start' || caller =~ m/^rise::lib::web::start\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $env; no warnings; sub env ():lvalue; *env = sub ():lvalue { $env }; use warnings; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  ($self,$env,$args) = ($_[0],$_[1],$_[2]);
                $self->header->{'status'}         = 404;
                $self->header->{'type'}         = 'text/html';
                $self->html           = 'ERROR 404: Not Found';
                $self->env            = $env;
                $self->args           = $args;

                my $app; no warnings; sub app ():lvalue; *app = sub ():lvalue { $app }; use warnings;  $app = $self->__route_eq;
                # self                        = self.__route_eq();
                # self.html               = app->app if app;

                if ($self->apptrue){
                    $self->header->{'status'}      = 200;
                    $self->html                   = $app->app;
                }

                return [$self->header->{'status'}, ['Content-Type'=> $self->header->{'type'} ], [$self->html]];
            }}};

            return Plack::Loader->auto->run($psgi_app);
        }}

        { package rise::lib::web::set_header; use rise::core::object::function;  sub set_header {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]); 
            $self->header         = $data;
            return $self->header;
        }}

        { package rise::lib::web::route; use rise::core::object::function;  sub route {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $rmeth; no warnings; sub rmeth ():lvalue; *rmeth = sub ():lvalue { $rmeth }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$rmeth,$data) = ($_[0],$_[1],$_[2]); 
            __RISE_PUSH $self->routes->{$rmeth}, [$data];
            return $self->routes->{$rmeth};
        }}

        { package rise::lib::web::get; use rise::core::object::function;  sub get {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings; my $controller; no warnings; sub controller ():lvalue; *controller = sub ():lvalue { $controller }; use warnings;  ($self,$route,$controller) = ($_[0],$_[1],$_[2]); 
            # self.dmsg(route);
            $self->route('GET', [$route, $controller]);
            return [$route, $controller];
        }}

        { package rise::lib::web::dmsg; use rise::core::object::function;  sub dmsg {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]); 
            use CGI;
            my $msg; no warnings; sub msg ():lvalue; *msg = sub ():lvalue { $msg }; use warnings; 
            $msg .= CGI::header();
        	$msg .= "<br>################################################<br>";
        	$msg .= $data;
        	$msg .= "<br>################################################<br>";
            say $msg;
            return $msg;
        }}

        { package rise::lib::web::__route_eq; use rise::core::object::function; sub __route_eq { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', '__route_eq') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            # self.dmsg(self);
            my $app; no warnings; sub app ():lvalue; *app = sub ():lvalue { $app }; use warnings; 
            $self->apptrue             = 0;
            { my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { $r }; use warnings;  foreach (@ {($self->routes->{$self->env->{'REQUEST_METHOD'}})}) { $r = $_;
                if ($self->env->{'REQUEST_URI'} =~ m{^(?:$r->[0])$}sx) {
                    $app = $r->[1];
                    $self->apptrue                = 1;
                    last;
                };
            }}
            return $app;
        }}

    }
}

1;