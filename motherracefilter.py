import pandas as pd

allwaves = pd.read_csv('background.csv', encoding_errors='ignore')

# filters by Mother race (baseline own report)
whitenonhispanic = allwaves[allwaves['cm1ethrace'] == 1]
whitenonhispanic.to_csv('Cwhitenonhispanic_mothers.csv')

blacknonhispanic = allwaves[allwaves['cm1ethrace'] == 2]
blacknonhispanic.to_csv('Cblacknonhispanic_mothers.csv')

hispanic = allwaves[allwaves['cm1ethrace'] == 3]
hispanic.to_csv('Chispanic_mothers.csv')

other = allwaves[allwaves['cm1ethrace'] == 4]
other.to_csv('other_mothers.csv')


# # filters by Mother religion
# protestantMother = allwaves[allwaves['m3r1'] == '2 Protestant']
# protestantMother.to_csv('Bprotestant_mothers.csv')

# catholicMother = allwaves[allwaves['m3r1'] == '1 Catholic']
# catholicMother.to_csv('catholic_mothers.csv')

# noprefMother = allwaves[allwaves['m3r1'] == '6 No Preference']
# noprefMother.to_csv('nopref_mothers.csv')

# otherChristianMother = allwaves[allwaves['m3r1'] == '104 Other Christian']
# otherChristianMother.to_csv('otherChristian_mothers.csv')

# muslimMother = allwaves[allwaves['m3r1'] == '4 Muslim']
# muslimMother.to_csv('muslim_mothers.csv')

# jewishMother = allwaves[allwaves['m3r1'] == '3 Jewish']
# jewishMother.to_csv('jewish_mothers.csv')

# otherMother = allwaves[allwaves['m3r1'] == '5 Other']
# otherMother.to_csv('other_mothers.csv')

# buddhistMother = allwaves[allwaves['m3r1'] == '101 Buddhist']
# buddhistMother.to_csv('buddhist_mothers.csv')

# hinduMother = allwaves[allwaves['m3r1'] == '102 Hindu']
# hinduMother.to_csv('hindu_mothers.csv')

# paganWiccanMother = allwaves[allwaves['m3r1'] == '103 Pagan/Wicca']
# paganWiccanMother.to_csv('paganWiccan_mothers.csv')

# # filters by Father religion

# protestantFather = allwaves[allwaves['f3r1'] == '2 Protestant']
# protestantFather.to_csv('protestant_fathers.csv')

# catholicFather = allwaves[allwaves['f3r1'] == '1 Catholic']
# catholicFather.to_csv('catholic_fathers.csv')

# noprefFather = allwaves[allwaves['f3r1'] == '6 No Preference']
# noprefFather.to_csv('nopref_fathers.csv')

# otherChristianFather = allwaves[allwaves['f3r1'] == '104 Other Christian']
# otherChristianFather.to_csv('otherChristian_fathers.csv')

# muslimFather = allwaves[allwaves['f3r1'] == '4 Muslim']
# muslimFather.to_csv('muslim_fathers.csv')

# jewishFather = allwaves[allwaves['f3r1'] == '3 Jewish']
# jewishFather.to_csv('jewish_fathers.csv')

# otherFather = allwaves[allwaves['f3r1'] == '5 Other']
# otherFather.to_csv('other_fathers.csv')

# buddhistFather = allwaves[allwaves['f3r1'] == '101 Buddhist']
# buddhistFather.to_csv('buddhist_fathers.csv')

# hinduFather = allwaves[allwaves['f3r1'] == '102 Hindu']
# hinduFather.to_csv('hindu_fathers.csv')

# paganWiccanFather = allwaves[allwaves['f3r1'] == '103 Pagan/Wicca']
# paganWiccanFather.to_csv('paganWiccan_fathers.csv')