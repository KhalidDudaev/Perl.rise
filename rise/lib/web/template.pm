use rise::lib::fs::file;

# using web::route;
{ package rise::lib::web; use rise::core::object::namespace;   
    { package rise::lib::web::template; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-compile  private-function-tag  private-var-thtml  private-var-file}} 

         sub thtml ():lvalue; no warnings; *__thtml__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'thtml') unless (caller eq 'rise::lib::web::template' || caller =~ m/^rise::lib::web::template\b/o); my $self = shift; $self->{'thtml'} }; *thtml = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'thtml') unless (caller eq 'rise::lib::web::template' || caller =~ m/^rise::lib::web::template\b/o); $__RISE_SELF__->{'thtml'} }; use warnings; 
         sub file ():lvalue; no warnings; *__file__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web::template' || caller =~ m/^rise::lib::web::template\b/o); my $self = shift; $self->{'file'} }; *file = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'file') unless (caller eq 'rise::lib::web::template' || caller =~ m/^rise::lib::web::template\b/o); $__RISE_SELF__->{'file'} }; use warnings;  file = new rise::lib::fs::file::;

        { package rise::lib::web::template::compile; use rise::core::object::function;  sub compile {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings; my $params; no warnings; sub params ():lvalue; *params = sub ():lvalue { $params }; use warnings;  ($tname,$params) = ($_[0],$_[1]); 
            # self.dmsg(tname);
            my $thtml; no warnings; sub thtml ():lvalue; *thtml = sub ():lvalue { $thtml }; use warnings;  $thtml = $self->file->read($tname);

            $thtml =~ s/ \[\[(\w+)\]\] / $params->{$1}||'' /gsxe;
            # templ =~ s/(\<\/?\w+\>)/\'$1\'/gsx;
            # thtml =~ s{\.\.\.}{\$self->tsay}gsx;
            # thtml =~ s{\.\.\.\s+(.*?)\;}{\$self->tsay($1);}gsx;
            $thtml =~ s{\.\.\.}{\$self->thtml .= }gsx;

            $thtml =~ s{
                \{\{(.*?)\}\}
            }{
                my $data = $1;
                eval $self->tag($data);
                die "TEMPLATE CODE ERROR\n".$@ if $@;
                $self->thtml;
            }gsxe;

            return $thtml;
        }}

        { package rise::lib::web::template::tag; use rise::core::object::function; sub tag { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'tag') unless (caller eq 'rise::lib::web::template' || caller =~ m/^rise::lib::web::template\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $str; no warnings; sub str ():lvalue; *str = sub ():lvalue { $str }; use warnings;  ($str) = ($_[0]); 
            # str =~ s{\>\s*\<}{\>\.\<}gsx;
            $str =~ s{(\<\/?\w+\>)}{\'$1\'}gsx;
            # str =~ s{[^\'](\<\/?\w+\>)[^\']}{\'$1\'}gsx;
            return $str;
        }}

    }
}

1;