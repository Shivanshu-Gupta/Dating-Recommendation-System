#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include <unordered_set>
#include <unordered_map>
#include <cstring>
#include <limits>

using namespace std;

#define minDeg 100

unordered_map<int, string> gender;
unordered_set<int> exclude;
void analyse(string in) {
    ifstream fin(in);
    string line;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        if(gender.find(u1) == gender.end()) {
            gender[u1] = g1;
        } else if(gender[u1] != g1) {
            exclude.insert(u1);
        }
        if(gender.find(u2) == gender.end()) {
            gender[u2] = g2;
        } else if(gender[u2] != g2) {
            exclude.insert(u2);
        }
    }
    fin.close(); fin.clear();
}

void filter(string in, string out) {
    analyse(in);
    cout<<gender.size()<<endl;
    cout<<exclude.size()<<endl;

    ifstream fin(in);
    ofstream fout(out, ios::out | ios::trunc);
    string line;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        // use this actions only if both users have consistent gender across dataset
        if(exclude.find(u1) == exclude.end() &&
            exclude.find(u2) == exclude.end()) {
            fout<<u1<<'\t'<<u2<<'\t'<<a<<'\t'<<g1<<'\t'<<g2<<'\n';
        }
    }
    fin.close(); fin.clear();
    fout.close(); fout.clear();
}


int main() {
    filter("../data/likeHidesWithGender.txt", "../data/actions.txt");
}