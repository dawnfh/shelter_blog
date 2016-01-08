

<a href = "/">Home</a>
<a href ='/profiles'>My Account</a>
<a href = "/">Logout</a>

<h1>My Followers</h1>

<ul>
  
  <% @users.each do |user| %>
    <li><bold>Id:</bold> <%= user.id %></h2>
    <li><bold>Email:</bold> <%= user.email %></li>
  <% end %>  
</ul>


<ul>
<% if current_user.followees.where(follows: { followee_id: user.id }).empty? %>
      <!-- if you are not following this user then display a follow link -->
      <li><a href="/users/<%= user.id %>/follow">Follow</a></li>
    <% else %>
      <!-- if you are following this user then display a unfollow link -->
      <li><a href="/users/<%= user.id %>/unfollow">Unfollow</a></li>
    <% end %>
  
  <% end %>
</ul>