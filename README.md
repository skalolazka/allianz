# allianz
Challenge number 1 for Allianz

## Prerequisites
Since this is a Vagrant configuration, to test this you need to have Vagrant installed.

## Running
You can run this simply as
```
vagrant up
```
This will start 5 virtual nodes in 2 Datacenters.
There will be 3 nodes in one datacenter (everything on one rack for simplicity) and 2 nodes in the other (one rack as well). There will be one cassandra seed in each datacenter.

## Explanation
I am unfortunately not able to test my solution properly since my computer is not good enough for it.
I am just hoping we are mostly judging the concept here.
I have written some comments in the script, but not much since I believe we will be discussing this onsite anyway and I will be able to explain my choice of configuration and maybe some syntax if you want.
There are some syntactic details I could have done better but I could spend a lot more time polishing this and I don't think the idea is about polishing it. I can gladly explain what I am talking about onsite.
