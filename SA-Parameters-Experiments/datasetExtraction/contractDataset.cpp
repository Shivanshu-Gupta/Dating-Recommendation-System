#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include <unordered_set>
#include <unordered_map>
#include <cstring>
#include <limits>

using namespace std;

#define minDeg 200

unordered_set <int> male, female;
unordered_map<int, int> indeg, outdeg;
int nActions = 0;
unordered_set<int> mostConnected;

void analyse(string in) {
    ifstream fin(in);
    string line;
    nActions = 0;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        iss >> u1 >> u2;
        if(outdeg.find(u1) == outdeg.end())
            outdeg[u1] = 0;
        outdeg[u1]++;
        
        if(indeg.find(u2) == indeg.end())
            indeg[u2] = 0;
        indeg[u2]++;

        string a, g1, g2;
        iss >> a >> g1 >> g2;
        if(g1 == "M") male.insert(u1);
        else female.insert(u1);
        if(g2 == "M") male.insert(u2);
        else female.insert(u2);
        nActions++;
    }

    for(auto pair : indeg) {
        int uid = pair.first;
        if(indeg[uid] > minDeg && outdeg[uid] > minDeg) {
            mostConnected.insert(uid);
        }
    }
    fin.close(); fin.clear();
}

void filter(string in, string out) {
    ifstream fin(in);
    ofstream fout(out, ios::out | ios::trunc);
    indeg.clear();
    outdeg.clear();
    nActions = 0;
    string line;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        iss >> u1 >> u2;
        //cout<<u1<<u2;
        if(mostConnected.find(u1) != mostConnected.end() && 
            mostConnected.find(u2) != mostConnected.end()) {
            if(outdeg.find(u1) == outdeg.end())
                outdeg[u1] = 0;
            outdeg[u1]++;
            
            if(indeg.find(u2) == indeg.end())
                indeg[u2] = 0;
            indeg[u2]++;
            
            fout << line << endl;
            nActions++;
        }
    }
    fin.close(); fin.clear();
    fout.close(); fout.clear();

    mostConnected.clear();
    for(auto pair : indeg) {
        int uid = pair.first;
        if(indeg[uid] > minDeg && outdeg[uid] > minDeg) {
            mostConnected.insert(uid);
        }
    }
}

int main() {
    string outfile[] = {"../data/train1.txt", "../data/train2.txt"};
    analyse(outfile[0]);
    cout<<mostConnected.size()<<' '<<nActions<<endl;
    for(int i = 0; mostConnected.size() > 2 * minDeg && nActions > minDeg * minDeg; i++) {
        filter(outfile[(i&1)], outfile[(i&1)^1]);
        cout<<outfile[(i&1)^1]<<": "<<mostConnected.size()<<' '<<nActions<<endl;
    }
}