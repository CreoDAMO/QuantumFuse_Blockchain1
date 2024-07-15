pub struct EnergyDAO {
    members: Vec<String>,
    proposals: Vec<Proposal>,
}

impl EnergyDAO {
    pub fn new() -> Self {
        EnergyDAO {
            members: vec![],
            proposals: vec![],
        }
    }

    pub fn add_member(&mut self, member: String) {
        self.members.push(member);
    }

    pub fn create_proposal(&mut self, proposal: Proposal) {
        self.proposals.push(proposal);
    }

    pub fn vote_on_proposal(&mut self, proposal_id: usize, member: String, vote: bool) {
        if let Some(proposal) = self.proposals.get_mut(proposal_id) {
            proposal.votes.insert(member, vote);
        }
    }

    pub fn tally_votes(&self, proposal_id: usize) -> Option<(usize, usize)> {
        self.proposals.get(proposal_id).map(|proposal| {
            let yes_votes = proposal.votes.values().filter(|&&v| v).count();
            let no_votes = proposal.votes.values().filter(|&&v| !v).count();
            (yes_votes, no_votes)
        })
    }
}

pub struct Proposal {
    pub id: usize,
    pub description: String,
    pub votes: HashMap<String, bool>,
}

impl Proposal {
    pub fn new(id: usize, description: String) -> Self {
        Proposal {
            id,
            description,
            votes: HashMap::new(),
        }
    }
}
