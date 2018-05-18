# frozen_string_literal: true
describe "Redis use" do

it "is accessible as 'redis'" do  
  expect(NYWalkerServer.settings.redis).to be_an_instance_of Redis  
end

  describe "NYWalkerServer::Redis::#cache" do
    # This is not my code, so hold off on testing.
  end

  describe "#nicknames_list" do
    let(:user){ create :user }
    let(:nick_list){ NYWalkerServer.nicknames_list }
    
    it "returns an Array" do
      expect(nick_list).to be_an Array
    end

    # it "of Hashes" do
    #   expect(nick_list.map{|n| n.class}.uniq).to contain_exactly Hash
    # end

    # it "of the form '{:string, :instance_count}'" do
    #   expect(nick_list.map{|n| n.keys}.uniq).to contain_exactly [:string, :instance_count]
    # end

    # it "where the :string is of the form 'nickname -- {place name}'" do
    #   expect(nick_list.select{|n| n[:string] =~ /-- {.*?}$/}.length).to eq nick_list.length
    # end

    # it "and it is sorted (descending) by :instance_count" do
    #   expect(nick_list.first[:instance_count]).to be > nick_list.last[:instance_count]
    # end

  end

end


