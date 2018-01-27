
 hextodec(s) =
    { my(v = Vecsmall(s), h = 0);
      for(i = 1, #v,
        h = (h<<4) + if(v[i]<=57, v[i]-48, if(v[i]<=70, v[i]-55, v[i]-87))
      );h;
    }
    
p=115792089210356248762697446949407573530086143415290314195533631308867097853951;
n=115792089210356248762697446949407573529996955224135760342422259061068512044369;
a=Mod(-3, p);
b=Mod(hextodec("5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b"), p);

P=Mod([hextodec("6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296"), hextodec("4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5")],p);


Q=Mod([hextodec("c97445f45cdef9f0d3e05e1e585fc297235b82b5be8ff3efca67c59852018192"), hextodec("b28ef557ba31dfcbdd21ac46e2a91e3c304f44cb87058ada2cb815151e610046")],p);
s=random(p-2)+2;
E=ellinit([0,0,0,a,b]);

generateur(s, a)={
	local(P1,r,P2,s1,Q1,t);
	if(a==0, return);
	
	P1=ellpow(E, P, s);
	
	r=lift(P1[1]);
	
	P2=ellpow(E, P,r);
	s1=lift(P2[1]);
	
	Q1=ellpow(E, Q,r);
	t=lift(Q1[1]);	
	
	print(t>>16 "\n");
	generateur(s1, a-1);
}
s=12010607244458510279584021697454260094694715108631900130468069520162379634547;
print("La graine utilise est :" s);
generateur(s, 11);

print("\n \n \n");
s=57711109851108234730215555078993943796905932300550333965027424539948213273;
print("La graine calcule est : " s);
generateur(s, 10);












