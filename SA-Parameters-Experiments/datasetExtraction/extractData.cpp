#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include <unordered_set>
#include <unordered_map>
#include <cstring>
#include <limits>

using namespace std;

#define minDeg 300

unordered_set <int> male, female;
unordered_map<int, int> indeg, outdeg;
unordered_set<int> mostConnected;

int main() {
    string outfile[] = {"../data/outf1.txt", "../data/outf2.txt"};
    int i = 0;
    int prevSize;
    float frac, prevFrac;
    ifstream fin;
    ofstream fout;
    while(1) {
        string in = (i > 1 ? outfile[i&1] : "../data/likeHidesWithGender.txt");
        string out = outfile[(i&1)^1];
        cout<<in<<' '<<out<<endl;
        fin.open(in);
        fout.open(out, ios::out | ios::trunc);
        indeg.clear();
        outdeg.clear();

        int k = 0, u1, u2;
        string line;
        while(getline(fin, line)) {
            istringstream iss(line);
            iss >> u1 >> u2;
            //cout<<u1<<u2;
            if(i == 0 || (mostConnected.find(u1) != mostConnected.end() && mostConnected.find(u2) != mostConnected.end())) {
                if(outdeg.find(u1) == outdeg.end())
                    outdeg[u1] = 0;
                outdeg[u1]++;
                if(indeg.find(u2) == indeg.end())
                    indeg[u2] = 0;
                indeg[u2]++;
                if(i > 0) fout << line << endl;

                if(i == 0) {
                    string a, g1, g2;
                    iss >> a >> g1 >> g2;
                    if(g1 == "M") male.insert(u1);
                    else female.insert(u1);
                    if(g2 == "M") male.insert(u2);
                    else female.insert(u2);
                }
                k++;
            }
        }
        fin.close(); fin.clear();
        fout.close(); fout.clear();

        prevSize = mostConnected.size();
        prevFrac = frac;
        mostConnected.clear();
        for(auto pair : indeg) {
            int uid = pair.first;
            if(indeg[uid] > minDeg && outdeg[uid] > minDeg) {
                mostConnected.insert(uid);
            }
        }
        cout<<k<<endl;
        cout<<mostConnected.size()<<endl;
        if(i > 0) {
            frac = mostConnected.size() / float(prevSize);
        }
        if(k <= 20000 || (i > 1 && frac < prevFrac)) {
            //for(int uid : mostConnected) {
            //    cout<<uid<<'\t'<<indeg[uid]<<'\t'<<outdeg[uid]<<endl;
            //}
            cout<<out<<endl;
            cout<<k<<endl;
            cout<<mostConnected.size()<<' '<<frac<<endl;
            break;
        }
        i++;
    }

}