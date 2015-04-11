function val = get(a,propName)
switch propName
    case 'x'
        val = a.x;
    case 'y'
        val = a.y;
    otherwise
            error([propName,' is not valid']);
end