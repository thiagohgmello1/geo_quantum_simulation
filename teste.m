color = [0 0 1];
bound = false;
contact_id = 0;
new_table = table(color, bound, contact_id);

color = [1 0 0];
bound = true;
contact_id = 1;
new_table_bound = table(color, bound, contact_id);

G_complete.Nodes(findnode(G_complete, '83'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '88'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '89'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '90'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '91'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '92'),3:5) = new_table;

G_complete.Nodes(findnode(G_complete, '135'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '136'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '137'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '138'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '139'),3:5) = new_table;
G_complete.Nodes(findnode(G_complete, '140'),3:5) = new_table;


G_complete.Nodes(findnode(G_complete, '93'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '94'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '95'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '96'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '97'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '98'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '99'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '100'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '101'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '102'),3:5) = new_table_bound;

contact_id = 2;
new_table_bound = table(color, bound, contact_id);

G_complete.Nodes(findnode(G_complete, '145'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '146'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '147'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '148'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '149'),3:5) = new_table_bound;
G_complete.Nodes(findnode(G_complete, '150'),3:5) = new_table_bound;







