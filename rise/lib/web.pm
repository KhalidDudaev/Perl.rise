# csdfsdf
# using Plack::Util;
# using Plack::Loader;
use CGI::Carp qw/fatalsToBrowser/;
use rise::lib::fs::file;
use rise::lib::web::route;
use rise::lib::web::server;
use rise::lib::web::template;

# using web::route;
{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::web; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1024131219"; sub VERSION {"2016.1024131219"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  export:simple-function-wsay  export:simple-function-out  export:simple-function-env  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg  private-var-file  private-var-route  private-var-server  private-var-tmpl  private-var-out  private-var-_qobj  private-var-_tout  private-var-args  private-var-apptrue  public-var-env  export:simple-function-wsay  export:simple-function-out  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg            public-class-server  public-class-server  export:simple-function-wsay  export:simple-function-out  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg            export:simple-function-wsay  export:simple-function-out  export:simple-function-env  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg           public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  export:simple-function-wsay  export:simple-function-out  export:simple-function-env  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg           public-class-route  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  public-class-server  export:simple-function-wsay  export:simple-function-out  export:simple-function-env  export:simple-function-req  export:simple-function-template  export:simple-function-tsay  export:simple-function-tout  export:simple-function-query  export:simple-function-start  export:simple-function-set_header  export:simple-function-setRoute  export:simple-function-get  export:simple-function-post  export:simple-function-put  export:simple-function-delete  export:simple-function-dmsg         }} sub __EXPORT__ { {":all"=>[qw/wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg env wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg/],":function"=>[qw/wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg/],":simple"=>[qw/wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg wsay out req template tsay tout query start set_header setRoute get post put delete dmsg env wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg wsay out env req template tsay tout query start set_header setRoute get post put delete dmsg/],":var"=>[qw/env/],"delete"=>[qw/delete delete delete delete delete delete/],"dmsg"=>[qw/dmsg dmsg dmsg dmsg dmsg dmsg/],"env"=>[qw/env env env env env/],"get"=>[qw/get get get get get get/],"out"=>[qw/out out out out out out/],"post"=>[qw/post post post post post post/],"put"=>[qw/put put put put put put/],"query"=>[qw/query query query query query query/],"req"=>[qw/req req req req req req/],"set_header"=>[qw/set_header set_header set_header set_header set_header set_header/],"setRoute"=>[qw/setRoute setRoute setRoute setRoute setRoute setRoute/],"start"=>[qw/start start start start start start/],"template"=>[qw/template template template template template template/],"tout"=>[qw/tout tout tout tout tout tout/],"tsay"=>[qw/tsay tsay tsay tsay tsay tsay/],"wsay"=>[qw/wsay wsay wsay wsay wsay wsay/],} } 

         sub file ():lvalue; no warnings; *__file__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'file'} }; *file = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'file'} }; use warnings;  file = new rise::lib::fs::file::;
         sub route ():lvalue; no warnings; *__route__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'route') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'route'} }; *route = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'route') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'route'} }; use warnings;  route = new rise::lib::web::route::;
         sub server ():lvalue; no warnings; *__server__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'server') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'server'} }; *server = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'server') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'server'} }; use warnings;  server = new rise::lib::web::server::;
         sub tmpl ():lvalue; no warnings; *__tmpl__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tmpl') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'tmpl'} }; *tmpl = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tmpl') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'tmpl'} }; use warnings;  tmpl = new rise::lib::web::template::;

        # var data;
         sub out ():lvalue; no warnings; *__out__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'out') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'out'} }; *out = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'out') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'out'} }; use warnings; 
         sub _qobj ():lvalue; no warnings; *___qobj__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_qobj') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'_qobj'} }; *_qobj = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_qobj') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'_qobj'} }; use warnings;  _qobj = {};
         sub _tout ():lvalue; no warnings; *___tout__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_tout') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'_tout'} }; *_tout = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', '_tout') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'_tout'} }; use warnings; 
         sub args ():lvalue; no warnings; *__args__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'args') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'args'} }; *args = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'args') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'args'} }; use warnings; 
         sub apptrue ():lvalue; no warnings; *__apptrue__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'apptrue') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); my $self = shift; $self->{'apptrue'} }; *apptrue = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'apptrue') unless (caller eq 'rise::lib::web' || caller =~ m/^rise::lib::web\b/o); $__RISE_SELF__->{'apptrue'} }; use warnings; 
        # export:simple var env                = {};

        { package rise::lib::web::wsay; use rise::core::object::function;  sub wsay {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]||''); 
            $self->out    .= $data;
            return $self->out;
        }}

        { package rise::lib::web::out; use rise::core::object::function;  sub out {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]||''); 
            $self->out    = $data;
            return $self->out;
        }}

        { package rise::lib::web::env; use rise::core::object::function;  sub env {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            return $self->server->env;
        }}

        { package rise::lib::web::req; use rise::core::object::function;  sub req {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
            $self->env->{'QUERY_STRING'} =~ s{\%22}{"}gsx;
            $self->env->{'QUERY_STRING'} =~ s{\%20}{ }gsx;
            # _env->{QUERY_STRING} =~ s{\:}{=>}gsx;
            return $self->env->{'QUERY_STRING'};
        }}

        { package rise::lib::web::template; use rise::core::object::function;  sub template {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings; my $params; no warnings; sub params ():lvalue; *params = sub ():lvalue { $params }; use warnings;  ($self,$tname,$params) = ($_[0],$_[1],$_[2]); 
            return $self->tmpl->compile($tname, $params);
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
            return $self->server->start($self->route);
        }}

        { package rise::lib::web::set_header; use rise::core::object::function;  sub set_header {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $head; no warnings; sub head ():lvalue; *head = sub ():lvalue { $head }; use warnings;  ($self,$head) = ($_[0],$_[1]); 
            return $self->server->set_header($head);
        }}

        { package rise::lib::web::setRoute; use rise::core::object::function;  sub setRoute {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $rmeth; no warnings; sub rmeth ():lvalue; *rmeth = sub ():lvalue { $rmeth }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$rmeth,$data) = ($_[0],$_[1],$_[2]); 
            $self->route->setRoute($rmeth, $data);
        }}

        { package rise::lib::web::get; use rise::core::object::function;  sub get {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings; my $controller; no warnings; sub controller ():lvalue; *controller = sub ():lvalue { $controller }; use warnings;  ($self,$route,$controller) = ($_[0],$_[1],$_[2]); 
            $self->setRoute('GET', [$route, $controller]);
            return [$route, $controller];
        }}

        { package rise::lib::web::post; use rise::core::object::function;  sub post {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings; my $controller; no warnings; sub controller ():lvalue; *controller = sub ():lvalue { $controller }; use warnings;  ($self,$route,$controller) = ($_[0],$_[1],$_[2]); 
            $self->setRoute('POST', [$route, $controller]);
            return [$route, $controller];
        }}

        { package rise::lib::web::put; use rise::core::object::function;  sub put {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings; my $controller; no warnings; sub controller ():lvalue; *controller = sub ():lvalue { $controller }; use warnings;  ($self,$route,$controller) = ($_[0],$_[1],$_[2]); 
            $self->setRoute('PUT', [$route, $controller]);
            return [$route, $controller];
        }}

        { package rise::lib::web::delete; use rise::core::object::function;  sub delete {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $route; no warnings; sub route ():lvalue; *route = sub ():lvalue { $route }; use warnings; my $controller; no warnings; sub controller ():lvalue; *controller = sub ():lvalue { $controller }; use warnings;  ($self,$route,$controller) = ($_[0],$_[1],$_[2]); 
            $self->setRoute('DELETE', [$route, $controller]);
            return [$route, $controller];
        }}

        { package rise::lib::web::dmsg; use rise::core::object::function;  sub dmsg {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$data) = ($_[0],$_[1]); 
            require CGI;
            my $msg; no warnings; sub msg ():lvalue; *msg = sub ():lvalue { $msg }; use warnings; 
            $msg .= CGI::header();
        	$msg .= "<br>################################################<br>";
        	$msg .= $data;
        	$msg .= "<br>################################################<br>";
            say $msg;
            return $msg;
        }}

    }
}

1;