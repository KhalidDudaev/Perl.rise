#sdfsfsfsdfsfd

use Carp;
use Crypt::Mode::CBC;
use Digest::SHA;
use Digest::SHA3;
use MIME::Base64;

# 'AES', 'Anubis', 'Blowfish', 'CAST5', 'Camellia', 'DES', 'DES_EDE',
# 'KASUMI', 'Khazad', 'MULTI2', 'Noekeon', 'RC2', 'RC5', 'RC6',
# 'SAFERP', 'SAFER_K128', 'SAFER_K64', 'SAFER_SK128', 'SAFER_SK64',
# 'SEED', 'Skipjack', 'Twofish', 'XTEA'

{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::crypt; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ }  sub engname ():lvalue; no warnings; *__engname__ = sub ():lvalue {  my $self = shift; $self->{'engname'} }; *engname = sub ():lvalue {  $__RISE_SELF__->{'engname'} }; use warnings;  sub pass ():lvalue; no warnings; *__pass__ = sub ():lvalue {  my $self = shift; $self->{'pass'} }; *pass = sub ():lvalue {  $__RISE_SELF__->{'pass'} }; use warnings;  sub __CLASS_ARGS__ { (engname,pass) = ($_[1]||'AES',$_[2]||'password' ); };sub __CLASS_MEMBERS__ {q{public-function-constructor  public-function-encrypt  public-function-decrypt  public-function-set_engine  public-function-set_sha1  public-function-set_sha3  public-function-password  public-function-b64encode  public-function-b64decode  public-function-rand_pass  public-function-rand_pass2  public-function-rand_bytes  public-var-sha1  public-var-sha3  public-var-crypt_eng  public-var-passhash  public-var-key  public-var-iv   }}  

        sub RAND_DEV () { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'RAND_DEV') unless (caller eq 'rise::lib::crypt' || caller =~ m/^rise::lib::crypt\b/o);'/dev/urandom' }

         sub sha1 ():lvalue; no warnings; *__sha1__ = sub ():lvalue {  my $self = shift; $self->{'sha1'} }; *sha1 = sub ():lvalue {  $__RISE_SELF__->{'sha1'} }; use warnings;  sha1 = new Digest::SHA:: 256;
         sub sha3 ():lvalue; no warnings; *__sha3__ = sub ():lvalue {  my $self = shift; $self->{'sha3'} }; *sha3 = sub ():lvalue {  $__RISE_SELF__->{'sha3'} }; use warnings;  sha3 = new Digest::SHA3:: 256;
         sub crypt_eng ():lvalue; no warnings; *__crypt_eng__ = sub ():lvalue {  my $self = shift; $self->{'crypt_eng'} }; *crypt_eng = sub ():lvalue {  $__RISE_SELF__->{'crypt_eng'} }; use warnings;  crypt_eng = new Crypt::Mode::CBC:: 'AES';
         sub passhash ():lvalue; no warnings; *__passhash__ = sub ():lvalue {  my $self = shift; $self->{'passhash'} }; *passhash = sub ():lvalue {  $__RISE_SELF__->{'passhash'} }; use warnings; 
         sub key ():lvalue; no warnings; *__key__ = sub ():lvalue {  my $self = shift; $self->{'key'} }; *key = sub ():lvalue {  $__RISE_SELF__->{'key'} }; use warnings; 
         sub iv ():lvalue; no warnings; *__iv__ = sub ():lvalue {  my $self = shift; $self->{'iv'} }; *iv = sub ():lvalue {  $__RISE_SELF__->{'iv'} }; use warnings; 

        { package rise::lib::crypt::constructor; use rise::core::object::function;  sub constructor {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $engname; no warnings; sub engname ():lvalue; *engname = sub ():lvalue { $engname }; use warnings; my $pass; no warnings; sub pass ():lvalue; *pass = sub ():lvalue { $pass }; use warnings;  ($engname,$pass) = ($_[0]||'AES',$_[1]||'password' ); 
            $self->engname            = $engname;
            $self->pass               = $pass;

            $self->password($pass);

            $self->crypt_eng         = new Crypt::Mode::CBC:: ( $self->engname );
            return $self;
        }}

        { package rise::lib::crypt::encrypt; use rise::core::object::function;  sub encrypt {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings; my $pass; no warnings; sub pass ():lvalue; *pass = sub ():lvalue { $pass }; use warnings;  ($data,$pass) = ($_[0],$_[1]); 
            $self->password($pass) if $pass;
        	return $self->crypt_eng->encrypt($data, $self->key, $self->iv);
        }}

        { package rise::lib::crypt::decrypt; use rise::core::object::function;  sub decrypt {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings; my $pass; no warnings; sub pass ():lvalue; *pass = sub ():lvalue { $pass }; use warnings;  ($data,$pass) = ($_[0],$_[1]); 
            $self->password($pass) if $pass;
        	return $self->crypt_eng->decrypt($data, $self->key, $self->iv);
        }}

        { package rise::lib::crypt::set_engine; use rise::core::object::function;  sub set_engine {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $engname; no warnings; sub engname ():lvalue; *engname = sub ():lvalue { $engname }; use warnings; my $key; no warnings; sub key ():lvalue; *key = sub ():lvalue { $key }; use warnings;  ($engname,$key) = ($_[0],$_[1]||$self.key ); 
            $self->crypt_eng         = new Crypt::Cipher:: ($engname, $key);
            return $self->crypt_eng;
        }}

        { package rise::lib::crypt::set_sha1; use rise::core::object::function;  sub set_sha1 {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $alg; no warnings; sub alg ():lvalue; *alg = sub ():lvalue { $alg }; use warnings;  ($alg) = ($_[0]||256 ); 
            $self->sha1          = new Digest::SHA:: $alg;
            return $self->sha1;
        }}

        { package rise::lib::crypt::set_sha3; use rise::core::object::function;  sub set_sha3 {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $alg; no warnings; sub alg ():lvalue; *alg = sub ():lvalue { $alg }; use warnings;  ($alg) = ($_[0]||256 ); 
            $self->sha3          = new Digest::SHA3:: $alg;
            return $self->sha3;
        }}

        { package rise::lib::crypt::password; use rise::core::object::function;  sub password {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $pass; no warnings; sub pass ():lvalue; *pass = sub ():lvalue { $pass }; use warnings;  ($pass) = ($_[0]||'password' ); 
            $self->pass              = $pass;
            $self->passhash          = $self->sha3->add($pass)->digest;

            # (self.key, self.iv)    = toList phash =~ m/ ^(.{16})(.{0,16}) /sx;
            ($self->key, $self->iv)    = toList __RISE_MATCH $self->passhash =~ m{^(.{16})(.{0,16})}sx;

            return $self->passhash;
        }}

        { package rise::lib::crypt::b64encode; use rise::core::object::function;  sub b64encode {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($data) = ($_[0]); 
            return MIME::Base64::encode_base64($data);
        }}

        { package rise::lib::crypt::b64decode; use rise::core::object::function;  sub b64decode {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($data) = ($_[0]); 
            return MIME::Base64::decode_base64($data);
        }}

        { package rise::lib::crypt::rand_pass; use rise::core::object::function;  sub rand_pass {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $len; no warnings; sub len ():lvalue; *len = sub ():lvalue { $len }; use warnings;  ($len) = ($_[0]||8); 
        	my $pass; no warnings; sub pass ():lvalue; *pass = sub ():lvalue { $pass }; use warnings; 
            my $letters; no warnings; sub letters ():lvalue; *letters = sub ():lvalue { $letters }; use warnings;  $letters = ['a'..'z',0..9,'A'..'Z','!','@','#','$','%','&','*','_','-','+','='];
        	srand();
        	$pass .= $letters->[ rand(@$letters) ] for (1..len);
        	return $pass;
        }}

        { package rise::lib::crypt::rand_pass2; use rise::core::object::function;  sub rand_pass2 {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $len; no warnings; sub len ():lvalue; *len = sub ():lvalue { $len }; use warnings;  ($len) = ($_[0]||8); 
        	return substr($self->sha3->add($self->rand_bytes ($len))->b64digest, 0, $len);
        }}

        { package rise::lib::crypt::rand_bytes; use rise::core::object::function;  sub rand_bytes {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $len; no warnings; sub len ():lvalue; *len = sub ():lvalue { $len }; use warnings;  ($len) = ($_[0]); 
            my $result; no warnings; sub result ():lvalue; *result = sub ():lvalue { $result }; use warnings; 

            if (-r $self->RAND_DEV && open(F,$self->RAND_DEV)) {
                read(F,$result,$len);
                close F;
            } else {
                $result = pack("C*", toList __RISE_MAP_BLOCK { rand(256) } [1..len]);
            }
            # Clear taint and check length
            __RISE_MATCH $result =~ m/^(.+)$/s;
            length($1) == $len or $self->croak ("Invalid length while gathering length random bytes");
            return $1;
        }}
    }

}

1;