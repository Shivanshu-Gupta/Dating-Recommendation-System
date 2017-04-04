#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include <unordered_set>
#include <unordered_map>
#include <cstring>
#include <limits>
#include <algorithm>
#include <cstdlib>

using namespace std;

#define minDeg 100

struct User {
    int id;
    char gender;
    int bucket;
    int indeg, outdeg;
    unordered_set<int> ratedBy, rated;
};

unordered_map<int, User> users;
vector<int> males, females;
int nActions = 0;
unordered_map<int, int> selected;
unordered_map<int, int> selectedMales, selectedFemales;

bool comp(const int &u1, const int &u2) {
    return (users[u1].indeg + users[u1].outdeg) > (users[u2].indeg + users[u2].outdeg);
}

void selectUsers(string in) {
    ifstream fin(in);
    string line;
    nActions = 0;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        if(users.find(u1) == users.end()) {
            User u = {u1, 'M', 0, 0, 1, {}, {u2}};
            if(g1 == "F") {
                u.gender = 'F';
                females.push_back(u1);
            } else {
                males.push_back(u1);
            }
            users[u1] = u;
        } else {
            users[u1].rated.insert(u2);
            users[u1].outdeg++;
        }
        if(users.find(u2) == users.end()) {
            User u = {u2, 'M', 0, 1, 0, {u1}, {}};
            if(g2 == "F") {
                u.gender = 'F';
                females.push_back(u2);
            } else {
                males.push_back(u2);
            }
            users[u2] = u;
        } else {
            users[u2].ratedBy.insert(u1);
            users[u2].indeg++;   
        }
    }
    fin.close(); fin.clear();
    cout<<"# males: "<<males.size()<<endl;
    cout<<"# females: "<<females.size()<<endl;
    
    sort(males.begin(), males.end(), comp);
    sort(females.begin(), females.end(), comp);
    int count = 1;
    int maleCount = 1, femaleCount = 1;
    for(int i = 0; i < 0.01 * float(males.size()); i++) {
        selected[males[i]] = count++;
        selectedMales[males[i]] = maleCount++;
    }
    for(int i = 0; i < 0.01 * float(females.size()); i++) {
        selected[females[i]] = count++;
        selectedFemales[females[i]] = femaleCount++;
    }
    cout<<"# males selected: "<<selectedMales.size()<<endl;
    cout<<"# females selected: "<<selectedFemales.size()<<endl;
}



void getTrain(string in, string out) {
    selectUsers(in);
    cout<<selected.size()<<endl;
    
    ifstream fin(in);
    ofstream fout(out, ios::out | ios::trunc);
    nActions = 0;
    string line;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        if(selected.find(u1) != selected.end() && 
            selected.find(u2) != selected.end()) {
            fout << selected[u1] << ',' << selected[u2] << ',';
            fout << ((a == "like") ? 1 : 0) << ',';
            fout << ((g1 == "M") ? 1 : 0) << ',';
            fout << ((g2 == "M") ? 1 : 0) << '\n';
            // if(a == "like")
            //     fout << "sigma(x("<< 2 * selected[u1] - 1 << "), x("<< 2 * selected[u2] << ")) *" << endl;
            // else 
            //     fout << "(1 - sigma(x("<< 2 * selected[u1] - 1 << "), x("<< 2 * selected[u2] << "))) *" << endl;
            nActions++;
        }
    }
    fin.close(); fin.clear();
    fout.close(); fout.clear();
}

void readBucketData(string bucketfile) {
    ifstream bucketf(bucketfile);
    string line;
    while(getline(bucketf, line)) {
        istringstream iss(line);
        int uid, bucket;
        iss >> uid >> bucket;
        if(users.find(uid) != users.end()) {
            users[uid].bucket = bucket;
        }
    }
}

void getTrainTest(string datafile, string trainfile, string testfile) {
    selectUsers(datafile);
    readBucketData("userId_Gender_Bucket.csv");
    cout<<selected.size()<<endl;
    
    ifstream fin(datafile);
    ofstream trainf(trainfile, ios::out | ios::trunc);
    ofstream testf(testfile, ios::out | ios::trunc);
    string line;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        if(selected.find(u1) != selected.end() && 
            selected.find(u2) != selected.end()) {
            double x = rand() / double(RAND_MAX);
            if(x < 0.1 && (users[u1].outdeg > 5 && users[u2].indeg > 5)) {
                testf << selected[u1] << ',' << selected[u2] << ',';
                testf << ((a == "like") ? 1 : 0) << ',';
                testf << ((g1 == "M") ? 1 : 0) << ',';
                testf << ((g2 == "M") ? 1 : 0) << ',';
                testf << users[u1].bucket << ',' << users[u2].bucket << ',';
                testf << u1 << ',' << u2 << '\n';
                users[u1].outdeg--;
                users[u2].indeg--;
            } else {
                trainf << selected[u1] << ',' << selected[u2] << ',';
                trainf << ((a == "like") ? 1 : 0) << ',';
                trainf << ((g1 == "M") ? 1 : 0) << ',';
                trainf << ((g2 == "M") ? 1 : 0) << ',';
                trainf << users[u1].bucket << ',' << users[u2].bucket << ',';
                trainf << u1 << ',' << u2 << '\n';
            }
        }
    }
    fin.close(); fin.clear();
    trainf.close(); trainf.clear();
    testf.close(); testf.clear();
}

// void getRatingMatrix(string datafile, string MFmatrixfile, string FMmatrixfile) {
//     selectUsers(datafile);
//     cout<<selected.size()<<endl;
//     vector< vector<int> > MFmatrix(selectedMales.size(), vector<int>(selectedFemales.size()));
//     vector< vector<int> > FMmatrix(selectedFemales.size(), vector<int>(selectedMales.size()));
//     ifstream fin(datafile);
//     string line;
//     while(getline(fin, line)) {
//         istringstream iss(line);
//         int u1, u2;
//         string a, g1, g2;
//         iss >> u1 >> u2 >> a >> g1 >> g2;
//         if(selected.find(u1) != selected.end() && 
//             selected.find(u2) != selected.end()) {
//             if(g1 == "M") {
//                 MFmatrix[selectedMales[u1] - 1][selectedFemales[u2] - 1] = (a == "like") ? 1 : 0;
//             } else {
//                 FMmatrix[selectedFemales[u1] - 1][selectedMales[u2] - 1] = (a == "like") ? 1 : 0;
//             }
//         }
//     }
//     ofstream mfmatrixf(MFmatrixfile, ios::out | ios::trunc);
//     for(auto femaleRatings : MFmatrix) {
//         for(auto r : femaleRatings) {
//             mfmatrixf << r << ',';
//         }
//         mfmatrixf << '\n';
//     }
//     ofstream fmmatrixf(FMmatrixfile, ios::out | ios::trunc);
//     for(auto maleRatings : FMmatrix) {
//         for(auto r : maleRatings) {
//             fmmatrixf << r << ',';
//         }
//         fmmatrixf << '\n';
//     }
// }

void convertData(string in, string out) {
    ifstream fin(in);
    ofstream fout(out, ios::out | ios::trunc);
    nActions = 0;
    unordered_map<int, int> users;
    string line;
    int count = 1;
    while(getline(fin, line)) {
        istringstream iss(line);
        int u1, u2;
        string a, g1, g2;
        iss >> u1 >> u2 >> a >> g1 >> g2;
        if(users.find(u1) == users.end()) {
            users[u1] = count++;
        }
        if(users.find(u2) == users.end()) {
            users[u2] = count++;
        }
        fout<<users[u1]<<','<<users[u2]<<',';
        fout << ((a == "like") ? 1 : 0) << ',';
        fout << ((g1 == "M") ? 1 : 0) << ',';
        fout << ((g2 == "M") ? 1 : 0) << '\n';
        // if(a == "like")
        //     fout << "sigma(x("<< 2 * selected[u1] - 1 << "), x("<< 2 * selected[u2] << ")) *" << endl;
        // else 
        //     fout << "(1 - sigma(x("<< 2 * selected[u1] - 1 << "), x("<< 2 * selected[u2] << "))) *" << endl;
        nActions++;
    }
    fin.close(); fin.clear();
    fout.close(); fout.clear();
}

int main() {
    getTrainTest("../data/train1.txt", "../data/train.csv", "../data/test.csv");
    // getRatingMatrix("../data/train1.txt", "../output/mfmatrix.csv", "../output/fmmatrix.csv");
    // convertData("../data/outf4.txt", "../data/train1.csv");
}