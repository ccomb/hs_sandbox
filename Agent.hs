module Agent where


data AgentType =
    AgentType
    { agentTypeName :: String }


data AgentGroup =
    AgentGroup
    { agentGroupName :: String
    , agentGroupGroups :: [AgentGroup] }


data Agent =
    Agent
    { agentName :: String
    , agentType :: AgentType
    , agentGroups :: [AgentGroup] }
