do local _ = {
  admins = {},
  disabled_channels = {},
  enabled_plugins = {
    "Administrative",
    "AutoDownload",
    "Auto-Lock",
    "Clean-Msg",
    "Forbidden",
    "Fun",
    "GroupManager",
    "Info-Pro",
    "Lock-Pro",
    "Limitmember",
    "Monshi-Bot",
    "Msg-Checks",
    "Practical",
    "SetUp-Plugins",
    "SetTag",
    "Warn",
    "Mod-Set",
    "Helper-Api",
    "Id",
    "Help-Api",
    "SetNerkh",
    "Limitmember-Helper"
  },
  enabled_plugins_api = {
    "Helper-Api",
    "Help-Api",
    "Limitmember-Helper"
  },
  moderation = {
    data = "./data/moderation.json"
  },
  sudo_users = {
    464555636,
    523769485,
    625203585,
    784614157,
    792814386
  }
}
return _
end