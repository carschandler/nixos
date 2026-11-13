{
  meta.users = rec {
    main = {
      username = "chan";
      name = "Cars Chandler";
    };
    # Users allowed to SSH in and added to admin-ish groups (docker, incus-admin, ...)
    admins = [ main.username ];
  };
}
