use orx_split_vec::SplitVec;
use std::collections::HashMap;

pub struct EnergyDAO {
    members: SplitVec<String>,       // Replacing Vec with SplitVec
    proposals: SplitVec<Proposal>,   // Replacing Vec with SplitVec
}

impl EnergyDAO {
    pub fn new() -> Self {
        EnergyDAO {
            members: SplitVec::new(),     // Initialize SplitVec for members
            proposals: SplitVec::new(),   // Initialize SplitVec for proposals
        }
    }

    pub fn add_member(&mut self, member: String) {
        self.members.push(member);        // Use SplitVec's push method
    }

    pub fn create_proposal(&mut self, proposal: Proposal) {
        self.proposals.push(proposal);    // Use SplitVec's push method
    }

    pub fn vote_on_proposal(&mut self, proposal_id: usize, member: String, vote: bool) {
        if let Some(proposal) = self.proposals.get_mut(proposal_id) {
            proposal.votes.insert(member, vote);  // Add or update the member's vote
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
