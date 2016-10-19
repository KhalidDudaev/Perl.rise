
{ package rise::lib::fs; use rise::core::object::namespace;   

    use rise::lib::fs::info;

    { package rise::lib::fs::dir; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{private-function-listhelper  public-function-list  public-function-listf  public-function-listd  private-function-filter  private-function-filterExtract  public-var-slash  private-var-info}} 

         sub slash ():lvalue; no warnings; *__slash__ = sub ():lvalue {  my $self = shift; $self->{'slash'} }; *slash = sub ():lvalue {  $__RISE_SELF__->{'slash'} }; use warnings; 
         sub info ():lvalue; no warnings; *__info__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'info') unless (caller eq 'rise::lib::fs::dir' || caller =~ m/^rise::lib::fs::dir\b/o); my $self = shift; $self->{'info'} }; *info = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'info') unless (caller eq 'rise::lib::fs::dir' || caller =~ m/^rise::lib::fs::dir\b/o); $__RISE_SELF__->{'info'} }; use warnings;  info = new rise::lib::fs::info::;

        { package rise::lib::fs::dir::listhelper; use rise::core::object::function; sub listhelper { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'listhelper') unless (caller eq 'rise::lib::fs::dir' || caller =~ m/^rise::lib::fs::dir\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            my $dlist; no warnings; sub dlist ():lvalue; *dlist = sub ():lvalue { $dlist }; use warnings;  $dlist = [];
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            __PACKAGE__->__RISE_ERR('ISDIR', $path) unless $self->info->isDir($path);

            $slash           = $self->slash || $slash;

            opendir(DIR, $path);
            { my $item; no warnings; sub item ():lvalue; *item = sub ():lvalue { $item }; use warnings;  foreach (readdir DIR) { $item = $_;
                __RISE_PUSH $dlist, $path . $item if __RISE_MATCH $item !~ m{^(?:\.|\.\.)$};
            }}
            closedir DIR;

            return $dlist;
        }}

        { package rise::lib::fs::dir::list; use rise::core::object::function;  sub list {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings; my $filtrItem; no warnings; sub filtrItem ():lvalue; *filtrItem = sub ():lvalue { $filtrItem }; use warnings;  ($self,$path,$filtrItem) = ($_[0],$_[1],$_[2]||'');
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { $res }; use warnings;  $res = [];
            my $dir; no warnings; sub dir ():lvalue; *dir = sub ():lvalue { $dir }; use warnings; 
            my $deep; no warnings; sub deep ():lvalue; *deep = sub ():lvalue { $deep }; use warnings;  $deep = 0;
            my $fltrN; no warnings; sub fltrN ():lvalue; *fltrN = sub ():lvalue { $fltrN }; use warnings;  $fltrN = 0;
            my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { $fltrD }; use warnings; 
            my $fltrDC; no warnings; sub fltrDC ():lvalue; *fltrDC = sub ():lvalue { $fltrDC }; use warnings; 
            my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { $fltrF }; use warnings; 
            my $filter; no warnings; sub filter ():lvalue; *filter = sub ():lvalue { $filter }; use warnings; 
            my $isD; no warnings; sub isD ():lvalue; *isD = sub ():lvalue { $isD }; use warnings;  $isD = 1;
            my $isF; no warnings; sub isF ():lvalue; *isF = sub ():lvalue { $isF }; use warnings;  $isF = 1;
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            $slash           = $self->slash || $slash;
            $isD             = 0 if $filtrItem eq 'file';
            $isF             = 0 if $filtrItem eq 'dir';
            $path            .= $slash if __RISE_MATCH $path =~ m{^.*?[^\\\/]$}sx && $isD;
            $path            = [$path] if ref $path ne 'ARRAY';

            { my $dname; no warnings; sub dname ():lvalue; *dname = sub ():lvalue { $dname }; use warnings;  foreach (@ {($path)}) { $dname = $_;
                $fltrDC = '';
                ($dir, $fltrD, $fltrF) = $self->filterExtract($dname);

                if ($fltrD && $fltrD =~ s{^([^\\\/]*)[\\\/]}{}sx){
                    $fltrDC = $1;
                }

                $fltrD = $fltrDC . $slash if $fltrDC eq '**';

                # dir         ||= dname;
                # fltrD       ||= '';
                # fltrF       ||= '*.*';

                # say 'dir      -> ' ~ dname;
                # say 'path     -> ' ~ dname;
                # say 'filter D -> ' ~ fltrDC ~ ' | ' ~ fltrD;
                # say 'filter F -> ' ~ fltrF;

                { my $item; no warnings; sub item ():lvalue; *item = sub ():lvalue { $item }; use warnings;  foreach (@ {($self->listhelper($dir))}) { $item = $_;
                    __RISE_PUSH $path, $item . $slash . $fltrD . $fltrF if $self->info->isDir($item) && $self->filter($item, $fltrDC);
                    __RISE_PUSH $res, $item if $self->info->isDir($item) && $isD && $self->filter($item, $fltrDC);
                    __RISE_PUSH $res, $item if $self->info->isFile($item) && $isF && $self->filter($item, $fltrF) && ($fltrDC eq '**' || !$fltrDC);
                    # say 'item -> ' ~ item;
                    # say 'path -> ' ~ dump path;
                }}
            }}

            return $res;
        }}

        { package rise::lib::fs::dir::listf; use rise::core::object::function;  sub listf {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'file');
        }}

        { package rise::lib::fs::dir::listd; use rise::core::object::function;  sub listd {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'dir');
        }}

        { package rise::lib::fs::dir::filter; use rise::core::object::function; sub filter { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filter') unless (caller eq 'rise::lib::fs::dir' || caller =~ m/^rise::lib::fs::dir\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings; my $fltr; no warnings; sub fltr ():lvalue; *fltr = sub ():lvalue { $fltr }; use warnings;  ($self,$name,$fltr) = ($_[0],$_[1],$_[2]);
            $fltr        =~ s{([^\w\*\?])}{\\$1}gsx;
            $fltr        =~ s{\*\\\.\*}{*(?:\\.*)?}gsx;
            $fltr        =~ s{(?<![()])\?}{\\w}gsx;
            $fltr        =~ s{(?<!\\)\*}{\.\*\?}gsx;
            $name        =~ s{^(.*?)(\w+(?:\.\w+)*)$}{$2}sx;
            return __RISE_MATCH $name =~ m{^(?:$fltr)$}gsx;
        }}

        { package rise::lib::fs::dir::filterExtract; use rise::core::object::function; sub filterExtract { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filterExtract') unless (caller eq 'rise::lib::fs::dir' || caller =~ m/^rise::lib::fs::dir\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
             my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { $fltrD }; use warnings; 
             my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { $fltrF }; use warnings; 
             ($path, $fltrD, $fltrF) = m{^([^\*\?]+[\\\/])([\w\?\*\.\\\/]+[\\\/])*([^\\\/]*)?$}sx;
            #  (path, fltrD, fltrF) = m{^([^\*\?]+[\\\/])(?:([\w\?\*\.]*)[\\\/])?([^\\\/]*)$}sx;
            #  (path, fltrD, fltrF) = m{^(.*?[\\\/])(?:(\*\*|\?+)[\\\/])?([^\\\/]+)?$}sx;
             return ($path, $fltrD, $fltrF);

            #  var filter;
            #  (path, filter) = m{^([^\*\?]+[\\\/])(.*?)$}sx;
            #  return (path, filter);
        }}

        # public function filterExpand(path) {
        #     var npath   = [];
        #     var npath2   = [];
        #     var cp;
        #     var fltr;
        #     var dir;
        #
        #     path            = [path] if ref path ne 'ARRAY';
        #
        #     foreach dir (path) {
        #         // (cp, fltr) = dir =~ m{^([^\*\?]+[\\\/])(?:([\w\?\*\.]*)[\\\/])?([^\\\/]*)$}sx;
        #         (cp, fltr) = dir =~ m{^(.*?[\\\/])(\*(?!\*).*?)$}sx;
        #         push npath2, cp;
        #         npath = self.listd(cp) if fltr;
        #         npath2 = clone npath;
        #         map { $_ ~= fltr } npath;
        #         push npath2, filterExpand(npath) if fltr;
        #     }
        #
        #     return npath2;
        # }

        # public function isFile (name) { -e name && !-d _ }
        # public function isDir  (name) { -d name }

    }
}

1;